# ❄️ NixHypr - Configuración NixOS + Hyprland + Impermanencia

Este repositorio contiene mi configuración personalizada de NixOS utilizando Hyprland como window manager, `impermanence` para un sistema volátil pero persistente cuando se necesita, y Home Manager para la gestión declarativa del entorno de usuario.

## 🚀 Pasos de instalación (modo impermanente radical)

### 1. Preparar entorno con Live ISO

- Usa una ISO mínima o personalizada de NixOS.
- Asegúrate de tener conexión a internet :b

### 2. Preparar particiones 
#### 2.1 Entrar a la consola de parted
```bash
sudo parted /dev/nvme0n1
```
Y una vez en parted, ejecutar:
```bash
mklabel gpt
mkpart ESP fat32 1MiB 512MiB
set 1 esp on
mkpart primary ext4 512MiB 100%
align-check optimal 1
align-check optimal 2
print
quit
```
#### 2.2 Formatear particiones
```bash
sudo mkfs.fat -F 32 /dev/nvme0n1p1
sudo mkfs.ext4 -L nix /dev/nvme0n1p2
```

#### 2.3 Montar las particiones para usar tmpfs
##### 2.3.1 Montar la raiz del sistema en ram
```bash
sudo mount -t tmpfs none /mnt
```
##### 2.3.2 Crear directorios estándar en /mnt
```bash
sudo mkdir -p /mnt/{boot,nix,etc/nixos}
```
/mnt/boot: para la partición EFI

/mnt/nix: para la partición persistente (donde irán /home, /etc/nixos, etc.)

/mnt/etc/nixos: la ruta donde estará tu configuración declarativa
##### 2.3.3 Montar la partición persistente en /mnt/nix
```bash
sudo mount /dev/disk/by-label/nix /mnt/nix
```
##### 2.3.4 Montar la partición EFI en /mnt/boot
```bash
sudo mount /dev/nvme0n1p1 /mnt/boot
```

##### 2.3.5 Vincular tu configuración persistente
```bash
sudo mkdir -p /mnt/nix/persist/etc/nixos
sudo mount --bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
```

### 3. Clonar el repositorio e instalar
