#!/usr/bin/env bash
set -euo pipefail

### CONFIGURACIÓN ###
POOL="zroot"
PREFIX="nixos"
USER="ccaverotx"
DISK="/dev/nvme0n1"
FLAKE_ATTR="desktop"
REPO_URL="https://github.com/ccaverotx/flakes-to-squeeze"
FLAKE_PATH="/mnt/persist/etc/nixos"

export NIX_CONFIG="experimental-features = nix-command flakes"

### PASO 0: BORRAR DISCO ###
echo "🚨 Borrando completamente el disco $DISK (sin confirmación)..."
wipefs -a "$DISK"

### PASO 1: Preparar directorios y clonar flake ###
echo "📁 Creando ruta para el flake: $FLAKE_PATH..."
mkdir -p "$FLAKE_PATH"
echo "🔽 Clonando flake desde $REPO_URL..."
git clone "$REPO_URL" "$FLAKE_PATH"

cd "$FLAKE_PATH"

### PASO 2: Ejecutar disko-install ###
echo "🧱 Ejecutando disko-install para $FLAKE_ATTR..."
nix run .#disko-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR} --disk main ${DISK}

### PASO 3: Montar tmpfs como raíz ###
echo "🔒 Montando / como tmpfs..."
mount -t tmpfs -o mode=755 tmpfs /mnt

### PASO 4: Crear directorios de montaje ###
echo "📂 Creando puntos de montaje..."
mkdir -p /mnt/nix /mnt/persist /mnt/boot /mnt/etc/nixos /mnt/home /mnt/var

### PASO 5: Montar datasets ZFS ###
echo "📦 Montando datasets ZFS..."
zpool list | grep -q "$POOL" || zpool import "$POOL"

mount -t zfs "$POOL/$PREFIX/nix" /mnt/nix
mount -t zfs "$POOL/$PREFIX/persist" /mnt/persist
mount -t zfs "$POOL/$PREFIX/persist/etc-nixos" /mnt/etc/nixos
mount -t zfs "$POOL/$PREFIX/persist/var" /mnt/var
mount -t zfs "$POOL/$PREFIX/persist/home" /mnt/home
mount -t zfs "$POOL/$PREFIX/persist/home/$USER" "/mnt/home/$USER"

### PASO 6: Montar partición EFI ###
echo "🧷 Montando partición EFI en /mnt/boot..."
mount ${DISK}p1 /mnt/boot

### PASO 7: Verificar puntos de montaje ###
echo "🔍 Verificando puntos de montaje..."
findmnt -R /mnt | grep -E "/mnt(/|$)"

### PASO 8: Instalar NixOS ###
echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
nix run .#nixos-install-${FLAKE_ATTR} -- --flake .#${FLAKE_ATTR}

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar."
