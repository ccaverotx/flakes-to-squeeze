#!/usr/bin/env bash

set -euo pipefail

DISK="/dev/nvme0n1"
FLAKE_ATTR="desktop"
FLAKE_PATH="/mnt/etc/nixos"

export NIX_CONFIG="experimental-features = nix-command flakes"

echo "🚨 Borrando completamente el disco $DISK (sin confirmación)..."
wipefs -a "$DISK"

echo "📁 Usando flake en $FLAKE_PATH..."
cd "$FLAKE_PATH"

echo "🧱 Ejecutando disko-install para $FLAKE_ATTR..."
nix run .#disko-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR}

echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
nix run .#nixos-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR}

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar."
