#
# Note: this install script is not officially supported and it is a beta version, I will fix it to work correctly and then I'll make it the oficial installation way
#

#!/usr/bin/env bash

# ---- CONFIGURACIÓN DE COLORES (Estilo Neón / la Makefile de Atomic-Linux) ----
CYAN='\033[0;36m'
PINK='\033[1;35m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # Sin color

# ---- BANNER DE INICIO ----
echo -e "${PINK}==================================================${NC}"
echo -e "${CYAN}  🛠️  INSTALANDO  INKORDIOUSDOTFILES ${NC}"
echo -e "${PINK}==================================================${NC}"

# ---- REQUISITO 1: Verificar si GNU Stow está instalado ----
echo -e "${CYAN}[CHECK]${NC} Verificando dependencias..."
if ! command -v stow &>/dev/null; then
  echo -e "${RED}[ERROR]${NC} 'stow' no está instalado."
  echo -e "         Por favor, instálalo usando tu gestor de paquetes."
  echo -e "         Ejemplo: 'sudo apt install stow', 'brew install stow', 'sudo pacman -S stow' o 'sudo dnf/dnf5 install stow'"
  exit 1
fi
echo -e "        ${GREEN}✔ Stow detectado correctamente.${NC}\n"

# ---- REQUISITO 2: Crear directorios base si no existen ----
echo -e "${CYAN}[DIR]${NC} Asegurando estructura en el HOME..."
DIRECTORIES=("$HOME/.config" "$HOME/.local/bin")

for dir in "${DIRECTORIES[@]}"; do
  if [ ! -d "$dir" ]; then
    echo -e "      Creando: ${YELLOW}$dir${NC}"
    mkdir -p "$dir"
  fi
done
echo -e "      ${GREEN}✔ Estructura de directorios lista.${NC}\n"

# ---- ACCIÓN: Ejecutar GNU Stow ----
echo -e "${CYAN}[STOW]${NC} Enlazando componentes de ${PINK}core${NC}..."

# -v (verbose) para que Stow liste las acciones, -R (restow) para reinstalar
if stow -vR core 2>&1 | sed "s/^/        /"; then
  echo -e "\n${PINK}================================================================${NC}"
  echo -e "${GREEN} ✨ ¡Instalación de InkordiousDotfiles completada con éxito! ✨${NC}"
  echo -e "${PINK}================================================================${NC}"
else
  echo -e "\n${RED}[ERROR] Hubo un problema al ejecutar GNU Stow.${NC}"
  exit 1
fi
