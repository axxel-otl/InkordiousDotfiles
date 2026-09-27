#!/usr/bin/env bash

# --- Settings ---
set -euo pipefail # Exit with fail, no unset variables, activate pipefails

# --- Color Configs ---
GREY="\033[38;2;169;174;239m" # #A9AEEF
# PINK="\033[38;2;255;92;120m"  # #FF5C78
GREEN="\033[38;2;155;254;206m" # #9BFECE
YELLOW="\033[38;2;255;245;155m" # #FFF59B
RED="\033[38;2;253;70;99m" # #FD4663
NC="\033[0m" # No Color

# --- [un]install ---
if [[ "${1:-}" == "-u" ]]; then
    # --- INK Banner ---
    echo -e "${GREY}=========================${NC}"
    echo -e "${GREY}  ██╗███╗   ██╗██╗  ██╗"
    echo -e "${GREY}  ██║████╗  ██║██║ ██╔╝"
    echo -e "${GREY}  ██║██╔██╗ ██║█████╔╝"
    echo -e "${GREY}  ██║██║╚██╗██║██╔═██╗"
    echo -e "${GREY}  ██║██║ ╚████║██║  ██╗"
    echo -e "${GREY}  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
    echo -e "${RED}  Dots${NC}: Uninstall"
    echo -e "${GREY}=========================${NC}"

    read -rp "Are you sure you want to uninstall the Inkordious Dotfiles (y/n) ? " u < /dev/tty
    if [[ ${u,,} == "y" ]]; then
        echo "The following files or directories are linked to the Inkordious Dotfiles: "
        syms=$(find "$HOME" -type l -lname '/opt/dots/*' 2> /dev/null; true)
        echo "$syms"
        echo
        read -rp "Remove them and the dotfiles repo (y/n) ? " u < /dev/tty
        if [[ ${u,,} == "y" ]]; then
            echo -e "${RED}Removing ${NC}/opt/dots..."
            if [[ -z syms ]]; then
                rm "$syms"
            fi
            sudo rm -rf "/opt/dots"
            echo -e "${GREEN}✅️ Finished uninstalling the Inkordious Dotfiles"
        else
            echo -e "${RED}Aborting Uninstall..."
        fi
    else
        echo -e "${RED}Aborting Uninstall..."
    fi
else
    # --- INK Banner ---
    echo -e "${GREY}=========================${NC}"
    echo -e "${GREY}  ██╗███╗   ██╗██╗  ██╗"
    echo -e "${GREY}  ██║████╗  ██║██║ ██╔╝"
    echo -e "${GREY}  ██║██╔██╗ ██║█████╔╝"
    echo -e "${GREY}  ██║██║╚██╗██║██╔═██╗"
    echo -e "${GREY}  ██║██║ ╚████║██║  ██╗"
    echo -e "${GREY}  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
    echo -e "${RED}  Dots${NC}: Install"
    echo -e "${GREY}=========================${NC}"

    # --- Ask distro ---
    declare -A distroArr=(["Arch Linux"]="arch" ["Bedrock Linux"]="bedrock")
    distro=$(gum choose "${!distroArr[@]}")
    distro="${distroArr[$distro]}"
    if [[ "$distro" == "arch" ]]; then
        baseCmd="pacman"
    elif [[ "$distro" == "bedrock" ]]; then
        baseCmd="pmm" # Here I should add the on-the-fly flag when it starts existing
    fi

    # --- Detect yq ---
    if ! "$baseCmd" -Qk "go-yq" &>/dev/null; then
        echo -e "${RED}❌️ ERROR${NC}: yq is required to run the installer"

        # --- Install yq ---
        echo -e "${YELLOW}❕️You can install yq this way${NC}: sudo $baseCmd -Sq go-yq"
        read -rp "Install yq (y/n) ? " install < /dev/tty
        if [[ ${install,,} == "y" ]]; then
            echo "Installing yq..."
            sudo "$baseCmd" -Sq go-yq
        else
            echo -e "${RED}ERROR${NC}: Couldn't install yq, aborting install..."
            exit 1
        fi
    fi

    # --- Manifest ---
    globalManifest=$(curl -LfsS "https://gitlab.com/axxel-otl/InkordiousDotfiles/-/raw/core/manifest.yaml?ref_type=heads")

    # --- Detect Dependencies ---
    keys=$(yq ".dependencies // {} | keys[]" <<< "$globalManifest")
    failed=()

    for k in $keys; do
        p=$(yq ".dependencies.$k.package // \"\"" <<< "$globalManifest")

        if "$baseCmd" -Qk "$p" &>/dev/null; then
            echo -e "${GREEN}✅️ $p is installed...${NC}"
        else
            echo -e "${RED}❌️ ERROR${NC}: package $p is not installed"
            failed+=("$p")
        fi
    done

    # --- Check if everything's right ---
    if (( ${#failed[@]} )); then
        echo -e "${RED}❌️ ERROR${NC}: Dependencies ${failed[*]} not installed"
        echo -e "${YELLOW}❕️You can install the missing dependencies this way${NC}: sudo $baseCmd -Sq ${failed[*]}"

        read -rp "Install (y/n) ? " install < /dev/tty
        if [[ ${install,,} == "y" ]]; then
            # Install missing dependencies
            sudo "$baseCmd" -Sq "${failed[@]}"
        else
            exit 1
        fi
    else
        echo -e "${GREEN}✅️ All dependencies installed${NC}"
    fi

    # --- Create dots directory ---
    sudo mkdir -p /opt/dots
    sudo chown "$USER:$USER" /opt/dots
    chmod 755 /opt/dots

    # --- Clone repos ---
    keys=$(yq ".repos // {} | keys[]" <<< "$globalManifest")
    for k in $keys; do
        if [[ $k == "dots" ]] || ( read -rp "Clone and install $k (y/n) ? " install < /dev/tty; [[ ${install,,} == "y" ]] ); then
            path="/opt/dots/$k"

            # --- Clone ---
            ssh=$(yq ".repos.$k.ssh // \"\"" <<< "$globalManifest")
            url=$(yq ".repos.$k.url // \"\"" <<< "$globalManifest")
            if ! git -C "$path" rev-parse --is-inside-work-tree &>/dev/null; then
                git clone "$ssh" "$path" || git clone "$url" "$path"
            fi
            # --- Update ---
            branch=$(yq ".repos.$k.branch // \"\"" <<< "$globalManifest")
            git -C "$path" switch "$branch"
            git -C "$path" pull
            tag=$(git -C "$path" tag --sort=-version:refname | head -n1)
            if [[ -n "$tag" ]]; then
                git -C "$path" switch --detach "$tag"
            fi

            # --- Install ---
            core=(
                $(yq -r ".syms.common // {} | keys[] | \".syms.common.\" + ." /opt/dots/"$k"/manifest.yaml)
                $(yq -r ".syms.$distro // {} | keys[] | \".syms.$distro.\" + ." /opt/dots/"$k"/manifest.yaml)
                $(yq -r ".make.common // {} | keys[] | \".make.common.\" + ." /opt/dots/"$k"/manifest.yaml)
                $(yq -r ".make.$distro // {} | keys[] | \".make.$distro.\" + ." /opt/dots/"$k"/manifest.yaml)
            )

            # --- Install Symlinks ---
            for i in "${core[@]}"; do
                origin=$(yq -r "$i.origin // \"\"" /opt/dots/"$k"/manifest.yaml)
                if [[ -z "$origin" ]]; then
                    exit 1
                fi
                origin=/opt/dots/"$k"/"$origin"

                destiny=$(yq -r "$i.destiny // \"\"" /opt/dots/"$k"/manifest.yaml)
                if [[ -z "$destiny" ]]; then
                    exit 1
                fi
                destiny="$HOME/$destiny"
                mkdir -p "$(dirname "$destiny")"

                # --- Check if file doesn't exist or is a symlink ---
                if [[ "$i" == .make.* && ! -e "$origin" ]]; then
                    content=$(yq -r "$i.content // \"\"" /opt/dots/"$k"/manifest.yaml)
                    echo "$content" > "$origin"
                fi

                if [[ -L "$destiny" || ! -e "$destiny" ]]; then
                    :
                elif read -rp "$destiny is a normal file and not a symlink, overwrite (y/n) ? " overwrite < /dev/tty; [[ "${overwrite,,}" == "y" ]]; then
                    rm "$destiny"
                else
                    continue
                fi

                # --- Create Symlinks ---
                ln -sfnv "$origin" "$destiny"
            done
        fi
    done

    # --- Say Goodbye XD ---
    echo -e "${GREEN}✅️ The Inkordious Dotfiles have been correctly installed"
fi