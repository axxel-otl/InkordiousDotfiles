# Comments that only contain "!" mean they're debugging commands and I will delete them when I finish this part of the install script

#!/usr/bin/env bash

# --- Settings ---
set -euo pipefail # exit with fail, no unset, activate pipefail

# --- Color Configs ---
GREY='\033[38;2;169;174;239m' # #A9AEEF
PINK='\033[38;2;255;92;120m'  # #FF5C78
GREEN='\033[38;2;155;254;206m' # #9BFECE
YELLOW='\033[38;2;255;245;155m' # #FFF59B
RED='\033[38;2;253;70;99m' # #FD4663
NC='\033[0m' # No Color

# --- INK banner ---
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
if ! paru -Qq go-yq &>/dev/null; then
    echo -e "${RED}❌️ ERROR${NC}: yq is required to run the installer"

    # --- Install yq ---
    cmd=(sudo pacman -Sq --needed extra/go-yq)
    echo "${cmd[0]}"
    echo -e "${YELLOW}❕️You can install yq this way${NC}: ${cmd[@]}"
    read -p "Install yq (y/n)? " i
    if [[ $i == "y" ]]; then
        echo "Installing yq..."
        sudo pacman -Sq --needed extra/go-yq
    else
        echo -e "${RED}ERROR${NC}: Couldn't install yq, aborting install..."
        exit 1
    fi
fi

# --- Detect Dependencies ---
k=$(yq ".dependencies | keys[]" ./manifest.yaml)
echo "$k" # !
failed=()

for d in ${k}; do
    p=$(yq ".dependencies.$d.package" ./manifest.yaml)
    r=$(yq ".dependencies.$d.repo" ./manifest.yaml)
    f="$r/$p"
    echo "$r, $p, $r/$p, $f" # !

    if ! pacman -Qq $p &>/dev/null; then
        echo -e "${RED}❌️ ERROR${NC}: package $r/$p is not installed"
        failed+=("$f")
    fi
done

if (( ${#failed[@]} )); then
    echo -e "${RED}❌️ ERROR${NC}: Dependencies ${failed[@]} not installed"

    cmd=(sudo pacman -Sq --needed "${failed[@]}")
    echo "${cmd[@]}"
    echo -e "${YELLOW}❕️You can install the missing dependencies this way${NC}: ${cmd[@]}"

    read -p "Install (y/n)? " i
    echo $i # !
    if [[ ${i,,} == "y" ]]; then
        # Install missing dependencies
        "${cmd[@]}"
        exit 1
    fi
else
    echo -e "${GREEN}✅️ All dependencies installed${NC}"
fi