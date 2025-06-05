#!/usr/bin/env bash
set -euo pipefail

POOL="zroot"
PREFIX="nixos"
USER="ccaverotx"

echo "[+] Montando / como tmpfs..."
mount -t tmpfs -o mode=755 tmpfs /mnt

echo "[+] Importando zpool $POOL..."
zpool import "$POOL"

echo "[+] Creando puntos de montaje..."
mkdir -p /mnt/nix
mkdir -p /mnt/persist
mkdir -p /mnt/boot
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/home
mkdir -p /mnt/var

echo "[+] Montando datasets ZFS..."
mount -t zfs "$POOL/$PREFIX/nix" /mnt/nix
mount -t zfs "$POOL/$PREFIX/persist" /mnt/persist
mount -t zfs "$POOL/$PREFIX/persist/etc-nixos" /mnt/etc/nixos
mount -t zfs "$POOL/$PREFIX/persist/var" /mnt/var
mount -t zfs "$POOL/$PREFIX/persist/home" /mnt/home
mount -t zfs "$POOL/$PREFIX/persist/home/$USER" "/mnt/home/$USER"

echo "[+] Montando partición EFI en /mnt/boot..."
mount /dev/nvme0n1p1 /mnt/boot

echo "[+] Verificando puntos de montaje..."
findmnt -R /mnt | grep -E "/mnt(/|$)"

echo "[✓] Todo montado correctamente. Puedes ejecutar nixos-install."
