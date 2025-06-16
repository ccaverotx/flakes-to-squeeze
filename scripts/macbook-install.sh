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

### PASO 5: Verificar puntos de montaje ###
echo "🔍 Verificando puntos de montaje..."
findmnt -n -o TARGET -R /mnt

### PASO 5.5: Re-clonar el flake dentro de /mnt/etc/nixos ###
echo "🔁 Re-clonando flake dentro de /mnt/etc/nixos para nixos-install..."
rm -rf /mnt/etc/nixos/.??* /mnt/etc/nixos/* || true
git clone "$REPO_URL" /mnt/etc/nixos

### PASO 6: Instalar NixOS ###
echo "🛠️ Ejecutando nixos-install para $FLAKE_ATTR..."
cd /mnt/etc/nixos
nix run .#nixos-install-"$FLAKE_ATTR" -- --flake .#"$FLAKE_ATTR"

### PASO 7: Rebuild final con nixos-enter ###
echo "🔄 Activando el perfil del sistema manualmente (nixos-rebuild switch)..."
nixos-enter --root /mnt --command "nixos-rebuild switch --flake /etc/nixos#$FLAKE_ATTR"

echo "✅ Instalación completa de $FLAKE_ATTR. Puedes reiniciar el sistema."
