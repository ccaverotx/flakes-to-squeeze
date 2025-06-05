#!/usr/bin/env bash
set -euo pipefail

# Nombre del zpool según tu configuración
POOL="zroot"
PREFIX="nixos"

echo "[+] Importando pool $POOL..."
zpool import "$POOL"

echo "[+] Creando puntos de montaje..."
mkdir -p /mnt/nix
mkdir -p /mnt/persist
mkdir -p /mnt/home
mkdir -p /mnt/var
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/boot

echo "[+] Montando datasets ZFS..."
mount -t zfs "$POOL/$PREFIX/nix" /mnt/nix
mount -t zfs "$POOL/$PREFIX/persist" /mnt/persist
mount -t zfs "$POOL/$PREFIX/persist/home" /mnt/home
mount -t zfs "$POOL/$PREFIX/persist/var" /mnt/var
mount -t zfs "$POOL/$PREFIX/persist/etc-nixos" /mnt/etc/nixos

echo "[+] Montando partición EFI en /mnt/boot..."
mount /dev/nvme0n1p1 /mnt/boot

echo "[+] Verificando puntos de montaje..."
findmnt -R /mnt | grep -E "/mnt(/|$)"

echo "[✓] Listo. Ya puedes ejecutar nixos-install."
