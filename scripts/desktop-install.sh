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

### INICIO: LIMPIEZA DE INSTALACIONES ANTERIORES ###

echo "🧹 Limpiando entorno anterior..."

echo "🔽 Desmontando /mnt si estaba montado..."
umount -R /mnt || echo "Nada montado en /mnt o ya desmontado."

echo "📤 Exportando pool ZFS (si está importado)..."
zpool export "$POOL" || echo "$POOL no estaba importado."

echo "💥 Destruyendo pool ZFS (si existe)..."
zpool destroy "$POOL" || echo "$POOL no existía o ya estaba destruido."

echo "🗑️ Eliminando flake clonado (si persiste)..."
rm -rf "$FLAKE_PATH"

echo "🧼 Borrando firma de sistema de archivos..."
wipefs -a "$DISK"

echo "💽 Borrando tabla de particiones..."
sgdisk --zap-all "$DISK"

### PASO 1: Montar tmpfs como raíz ###
echo "🔒 Montando / como tmpfs..."
mount -t tmpfs -o mode=755 tmpfs /mnt

### PASO 2: Crear puntos de montaje previos ###
echo "📂 Creando puntos de montaje previos..."
mkdir -p /mnt/boot /mnt/persist

### PASO 3: Clonar el flake AHORA que persistirá en tmpfs →
echo "🔽 Clonando flake desde $REPO_URL..."
git clone "$REPO_URL" "$FLAKE_PATH"

cd "$FLAKE_PATH"

### PASO 3.5: Comentar todo lo relacionado con lanzaboote ###
echo "📝 Comentando lanzaboote del flake..."

# Comentar input lanzaboote
sed -i 's/^\([[:space:]]*\)lanzaboote\(.*\)/\1# lanzaboote\2/' flake.nix

# Comentar usos en la lista de outputs
sed -i 's/^\([[:space:]]*\)lanzaboote\.nixosModules\.lanzaboote/\1# lanzaboote.nixosModules.lanzaboote/' flake.nix

# Comentar usoLanzaboote en la tabla de hosts
sed -i 's/\([[:space:]]*useLanzaboote = \)true;/\1false; # originalmente true/' flake.nix

### PASO 4: Ejecutar disko-install ###
echo "🧱 Ejecutando disko-install para $FLAKE_ATTR..."
nix run .#disko-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR" --disk main "$DISK"

### PASO 5: Montar partición EFI (ya existe después del disko-install) ###
echo "🧷 Montando partición EFI en /mnt/boot..."
mount "${DISK}p1" /mnt/boot

### PASO 6: Crear directorios adicionales (por si acaso) ###
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

# 🔧 Crear punto de montaje para el usuario antes de montar
mkdir -p /mnt/home/"$USER"
mount -t zfs "$POOL/$PREFIX/persist/home/$USER" "/mnt/home/$USER"

### PASO 8: Verificar puntos de montaje ###
echo "🔍 Verificando puntos de montaje..."
findmnt -n -o TARGET -R /mnt

### PASO 8.5: Clonar nuevamente el flake dentro de /mnt/etc/nixos ###
echo "🔁 Re-clonando flake dentro de /mnt/etc/nixos para nixos-install..."
rm -rf /mnt/etc/nixos/.??* /mnt/etc/nixos/* || true
git clone "$REPO_URL" /mnt/etc/nixos

### PASO 8.6: Comentar lanzaboote del flake clonado en /mnt/etc/nixos ###
echo "📝 Comentando lanzaboote en el flake de /mnt/etc/nixos..."

sed -i 's/^\([[:space:]]*\)lanzaboote\(.*\)/\1# lanzaboote\2/' /mnt/etc/nixos/flake.nix
sed -i 's/^\([[:space:]]*\)lanzaboote\.nixosModules\.lanzaboote/\1# lanzaboote.nixosModules.lanzaboote/' /mnt/etc/nixos/flake.nix
sed -i 's/\([[:space:]]*useLanzaboote = \)true;/\1false; # originalmente true/' /mnt/etc/nixos/flake.nix
sed -i 's/\([[:space:]]*outputs = {[^}]*\)lanzaboote,/\1# lanzaboote,/' /mnt/etc/nixos/flake.nix

### PASO 9: Instalar NixOS ###
echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
cd /mnt/etc/nixos
nix run .#nixos-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR"

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar el sistema."
#sudo chown -R ccaverotx:users /etc/nixos importante, despues para trabajar en etc/nixos
