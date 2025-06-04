#!/usr/bin/env bash

set -euo pipefail

DISK="/dev/nvme0n1"
FLAKE_ATTR="desktop"
FLAKE_PATH="/mnt/etc/nixos"

export NIX_CONFIG="experimental-features = nix-command flakes"

echo "🚨 Borrando completamente el disco $DISK (sin confirmación)..."
wipefs -a "$DISK"

echo "📁 Montando estructura en $FLAKE_PATH..."
mkdir -p "$FLAKE_PATH"

# Clona solo si no está presente
if [ ! -d "$FLAKE_PATH/.git" ]; then
  echo "🌱 Clonando flake de configuración..."
  git clone https://github.com/ccaverotx/flakes-to-squeeze "$FLAKE_PATH"
fi

cd "$FLAKE_PATH"

echo "🧱 Ejecutando disko-install para $FLAKE_ATTR..."
nix run .#disko-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR}

echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
nix run .#nixos-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR}

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar."
