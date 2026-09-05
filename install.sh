# Comments that only contain "!" mean they're debugging commands and I will delete them when I finish this part of the install script

#!/usr/bin/env bash

# --- Settings ---
set -euo pipefail

# --- Color Configs ---
GREY='\033[38;2;169;174;239m' # #A9AEEF
PINK='\033[38;2;255;92;120m'  # #FF5C78
GREEN='\033[38;2;155;254;206m' # #9BFECE
YELLOW='\033[38;2;255;245;155m' # #FFF59B
RED='\033[38;2;253;70;99m' # #FD4663
NC='\033[0m' # Sin color

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

# Now I should make it search for dependencies but idk how to check them, I'll improvise
DEPS=$(yq ".dependencies | keys[]" ./manifest.yaml)
echo "$DEPS" # !
failed=()

for d in ${DEPS};
do
    p=$(yq ".dependencies.$d.package" ./manifest.yaml)
    r=$(yq ".dependencies.$d.repo" ./manifest.yaml)
    echo "$r/$p" # !
    if ! pacman -Qq $p &>/dev/null; then
        echo -e "${RED}❌️ ERROR${NC}: package $r/$p is not installed"
        failed+=("$r/$p")
    fi
done
if ((${#failed[@]})); then
    echo -e "${RED}❌️ ERROR${NC}: Failed installing ${GREY}Inkordious Dotfiles${NC} due to package not installed"
    echo "${failed[@]}"
    exit 1
else
    echo -e "${GREEN}✅️ All dependencies installed${NC}"
fi