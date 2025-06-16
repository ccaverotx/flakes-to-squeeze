#!/usr/bin/env bash
set -euo pipefail

### CONFIGURACIÓN ###
USER="ccaverotx"
DISK="/dev/sda"
FLAKE_ATTR="macbook-pro-2015"
REPO_URL="https://github.com/ccaverotx/flakes-to-squeeze"
FLAKE_PATH="/mnt/persist/etc/nixos"

export NIX_CONFIG="experimental-features = nix-command flakes"

### INICIO: LIMPIEZA DE INSTALACIONES ANTERIORES ###
echo "🧹 Limpiando entorno anterior..."

umount -R /mnt || echo "Nada montado en /mnt o ya desmontado."
rm -rf "$FLAKE_PATH"
wipefs -a "$DISK"
sgdisk --zap-all "$DISK"

### PASO 1: Montar tmpfs como raíz ###
echo "🔒 Montando / como tmpfs..."
mount -t tmpfs -o mode=755,size=4G tmpfs /mnt

### PASO 2: Crear puntos de montaje previos ###
echo "📂 Creando puntos de montaje previos..."
mkdir -p /mnt/boot /mnt/persist

### PASO 3: Clonar el flake ###
echo "🔽 Clonando flake desde $REPO_URL..."
git clone "$REPO_URL" "$FLAKE_PATH"
cd "$FLAKE_PATH"

### PASO 4: Ejecutar disko-install ###
echo "🧱 Ejecutando disko-install para $FLAKE_ATTR..."
nix run .#disko-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR" --disk main "$DISK"

### PASO 5: Montar los subvolúmenes manualmente ###
echo "📦 Montando subvolúmenes Btrfs..."
mount -o subvol=/ /dev/sda2 /mnt
mount -o subvol=/nix,compress=zstd,noatime /dev/sda2 /mnt/nix
mount -o subvol=/persist,compress=zstd,noatime /dev/sda2 /mnt/persist
mount -o subvol=/persist/etc-nixos /dev/sda2 /mnt/persist/etc-nixos
mount -o subvol=/persist/var /dev/sda2 /mnt/persist/var
mount -o subvol=/persist/home /dev/sda2 /mnt/persist/home
mount -o subvol=/persist/home/$USER /dev/sda2 /mnt/persist/home/$USER

### PASO 6: Montar partición EFI ###
echo "🧷 Montando partición EFI en /mnt/boot..."
mount "${DISK}1" /mnt/boot

### PASO 7: Verificar puntos de montaje ###
echo "🔍 Verificando puntos de montaje..."
findmnt -R /mnt

### PASO 8: Re-clonar flake dentro de /mnt/etc/nixos ###
echo "🔁 Re-clonando flake dentro de /mnt/etc/nixos para nixos-install..."
rm -rf /mnt/etc/nixos/.??* /mnt/etc/nixos/* || true
git clone "$REPO_URL" /mnt/etc/nixos

### PASO 9: Instalar NixOS ###
echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
cd /mnt/etc/nixos
nix run .#nixos-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR"

### PASO 10: Activación manual del sistema con nixos-enter ###
echo "🔄 Activando el perfil del sistema manualmente (nixos-rebuild switch)..."
nixos-enter --root /mnt --command "nixos-rebuild switch --flake /etc/nixos#$FLAKE_ATTR"

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar el sistema."
