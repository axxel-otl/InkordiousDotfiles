#!/usr/bin/env bash

# --- Settings ---
set -euo pipefail # Exit with fail, no unset variables, activate pipefails
owd=$(pwd)

# --- Color Configs ---
GREY="\033[38;2;169;174;239m" # #A9AEEF
PINK="\033[38;2;255;92;120m"  # #FF5C78
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
    echo -e "${RED}  Dots${NC}: uninstall"
    echo -e "${GREY}=========================${NC}"

    read -rp "Are you sure you want to uninstall the Inkordious Dotfiles(y/n)?" u
    if [[${u,,} == "y"]]; then
        echo -e "${RED}Removing ${NC}/opt/dots..."
        sudo rm -rf "/opt/dots"
        echo -e "${GREEN}✅️ Finished uninstalling the Inkordious Dotfiles"
    else
        echo -e "${READ}Aborting Uninstall..."
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
    echo -e "${RED}  Dots${NC}: install"
    echo -e "${GREY}=========================${NC}"

    # --- Detect yq ---
    if ! pacman -Qq "go-yq" &>/dev/null; then
        echo -e "${RED}❌️ ERROR${NC}: yq is required to run the installer"

        # --- Install yq ---
        cmd=(sudo pacman -Sq --needed "extra/go-yq")
        echo -e "${YELLOW}❕️You can install yq this way${NC}: ${cmd[@]}"
        read -rp "Install yq (y/n)? " install
        if [[ ${install,,} == "y" ]]; then
            echo "Installing yq..."
            sudo pacman -Sq --needed "extra/go-yq"
        else
            echo -e "${RED}ERROR${NC}: Couldn't install yq, aborting install..."
            cd $owd
            exit 1
        fi
    fi

    # --- Manifest ---
    globalManifest=$(curl -LfsS "https://gitlab.com/axxel-otl/InkordiousDotfiles/-/raw/core/manifest.yaml?ref_type=heads")

    # --- Detect Dependencies ---
    keys=$(yq ".dependencies // {} | keys[]" <<< $globalManifest)
    failed=()

    for k in $keys; do
        p=$(yq ".dependencies.$k.package // ''" <<< $globalManifest)
        r=$(yq ".dependencies.$k.repo // ''" <<< $globalManifest)
        f="$r/$p"

        if pacman -Qq "$p" &>/dev/null; then
            echo -e "${GREEN}✅️ $f is installed...${NC}"
        else
            echo -e "${RED}❌️ ERROR${NC}: package $r/$p is not installed"
            failed+=("$f")
        fi
    done

    # --- Check if everything's right ---
    if (( ${#failed[@]} )); then
        echo -e "${RED}❌️ ERROR${NC}: Dependencies ${failed[@]} not installed"

        cmd=(sudo pacman -Sq --needed "${failed[@]}")
        echo "${cmd[@]}"
        echo -e "${YELLOW}❕️You can install the missing dependencies this way${NC}: ${cmd[@]}"

        read -rp "Install (y/n)? " install
        if [[ ${install,,} == "y" ]]; then
            # Install missing dependencies
            "${cmd[@]}"
        else
            cd $owd
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
    keys=$(yq ".repos // {} | keys[]" <<< $globalManifest)
    for k in $keys; do
        if [[ $k == "dots" ]] || ( read -rp "Clone and install $k (y/n)? " install; [[ ${install,,} == y ]] ); then
            route="/opt/dots/$k"

            # --- Clone ---
            ssh=$(yq ".repos.$k.ssh // ''" <<< $globalManifest)
            url=$(yq ".repos.$k.url // ''" <<< $globalManifest)
            git clone "$ssh" "$route" || git clone "$url" "$route"

            # --- Install ---
            for 
        fi
    done

    # --- Go Back to the Original Working Directory
    cd $owd
fi