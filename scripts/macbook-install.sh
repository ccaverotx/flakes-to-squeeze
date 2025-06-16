#!/usr/bin/env bash
set -euo pipefail

### CONFIGURACIÓN ###
POOL="zroot"
PREFIX="nixos"
USER="ccaverotx"
DISK="/dev/sda"
FLAKE_ATTR="macbook-pro"
REPO_URL="https://github.com/ccaverotx/flakes-to-squeeze"
FLAKE_PATH="/mnt/persist/etc/nixos"

export NIX_CONFIG="experimental-features = nix-command flakes"

### INICIO: LIMPIEZA DE INSTALACIONES ANTERIORES ###
echo "🧹 Limpiando entorno anterior..."

umount -R /mnt || echo "Nada montado en /mnt o ya desmontado."
zpool export "$POOL" || echo "$POOL no estaba importado."
zpool destroy "$POOL" || echo "$POOL no existía o ya estaba destruido."
rm -rf "$FLAKE_PATH"
wipefs -a "$DISK"
sgdisk --zap-all "$DISK"

### PASO 1: Montar tmpfs como raíz ###
echo "🔒 Montando / como tmpfs..."
mount -t tmpfs -o mode=755 tmpfs /mnt

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

### PASO 5: Montar partición EFI ###
echo "🧷 Montando partición EFI en /mnt/boot..."
mount "${DISK}1" /mnt/boot

### PASO 6: Crear directorios adicionales ###
echo "📁 Creando puntos de montaje adicionales..."
mkdir -p /mnt/{nix,persist,etc/nixos,home,var}

### PASO 7: Importar y montar datasets ZFS ###
echo "📦 Importando y montando datasets ZFS..."
if ! zpool list | grep -q "$POOL"; then
  zpool import "$POOL"
fi

mount -t zfs "$POOL/$PREFIX/nix" /mnt/nix
mount -t zfs "$POOL/$PREFIX/persist" /mnt/persist
mount -t zfs "$POOL/$PREFIX/persist/etc-nixos" /mnt/etc/nixos
mount -t zfs "$POOL/$PREFIX/persist/var" /mnt/var
mount -t zfs "$POOL/$PREFIX/persist/home" /mnt/home

mkdir -p /mnt/home/"$USER"
mount -t zfs "$POOL/$PREFIX/persist/home/$USER" "/mnt/home/$USER"

### PASO 8: Verificar puntos de montaje ###
echo "🔍 Verificando puntos de montaje..."
findmnt -n -o TARGET -R /mnt

### PASO 8.5: Clonar nuevamente el flake dentro de /mnt/etc/nixos ###
echo "🔁 Re-clonando flake dentro de /mnt/etc/nixos para nixos-install..."
rm -rf /mnt/etc/nixos/.??* /mnt/etc/nixos/* || true
git clone "$REPO_URL" /mnt/etc/nixos

### PASO 9: Instalar NixOS ###
echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
cd /mnt/etc/nixos
nix run .#nixos-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR"

### PASO 10: Rebuild final con nixos-enter ###
echo "🔄 Activando el perfil del sistema manualmente (nixos-rebuild switch)..."
nixos-enter --root /mnt --command "nixos-rebuild switch --flake /etc/nixos#$FLAKE_ATTR"

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar el sistema."

# sudo chown -R ccaverotx:users /etc/nixos # Opcional tras el primer ingreso
