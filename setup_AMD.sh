#!/bin/bash

# --- RENKLER ---
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${RED}#############################################################${RESET}"
echo -e "${RED}#        DAVINCI RESOLVE INSTALLER (AMD EDITION)            #${RESET}"
echo -e "${RED}#          (OpenCL Sürücüleri ve Gerekli Yamalar)           #${RESET}"
echo -e "${RED}#############################################################${RESET}"

# 1. ROOT KONTROLÜ
if [ "$EUID" -ne 0 ]; then
  echo -e "${YELLOW}❌ Lütfen yönetici yetkisiyle çalıştırın: sudo ./setup_amd.sh${RESET}"
  exit
fi

# 2. SİSTEM TESPİTİ
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "${RED}❌ Dağıtım bilgisi okunamadı!${RESET}"
    exit 1
fi

# 3. BAĞIMLILIKLAR (AMD ÖZEL)
install_dependencies() {
    echo -e "${BLUE}🔧 AMD OpenCL ve Sistem kütüphaneleri hazırlanıyor...${RESET}"
    
    case $OS in
        ubuntu|debian|linuxmint|pop|kali|neon)
            apt update
            
            # Temel Paketler + AMD OpenCL (mesa-opencl-icd)
            PKGS="libapr1 libaprutil1 libglib2.0-0 libxcb-composite0 libxcb-cursor0 \
            libxcb-xinerama0 libxcb-xinput0 libxcb-icccm4 libxcb-render-util0 \
            libxcb-shape0 libxkbcommon-x11-0 mesa-opencl-icd ocl-icd-libopencl1 opencl-headers"
            
            # t64 (Ubuntu 24.04+) Kontrolü
            if apt-cache show libasound2 >/dev/null 2>&1; then
                PKGS="$PKGS libasound2"
            else
                PKGS="$PKGS libasound2t64"
                NEEDS_SYMLINK_ASOUND=true
            fi
            
            # libapr Kontrolü
            if ! apt-cache show libapr1 >/dev/null 2>&1; then
                 PKGS="$PKGS libapr1t64 libaprutil1t64"
            fi

            apt install -y $PKGS
            ;;
        
        fedora|nobara)
            # Fedora için AMD Paketleri
            dnf install -y apr apr-util alsa-lib mesa-libGLU libxcb libX11 libXext \
            libXfixes libXi libXrender libXcursor libXinerama libxkbcommon-x11 \
            mesa-libOpenCL ocl-icd
            ;;
            
        arch|manjaro|endeavouros)
            # Arch için AMD Paketleri
            pacman -S --needed --noconfirm base-devel apr apr-util alsa-lib mesa-libglu \
            libxcb libx11 libxext libxfixes libxi libxrender libxcursor libxinerama \
            libxkbcommon-x11 opencl-mesa ocl-icd
            ;;
    esac
}

# 4. SYMLINK HACK (Sadece Debian/Ubuntu için)
apply_symlink_hacks() {
    LIB_PATH="/usr/lib/x86_64-linux-gnu"
    if [ "$NEEDS_SYMLINK_ASOUND" = true ]; then
        if [ -f "$LIB_PATH/libasound.so.2" ] && [ ! -f "$LIB_PATH/libasound2.so.2" ]; then
            echo -e "${YELLOW}🛠️  Ses kartı yaması uygulanıyor...${RESET}"
            ln -s "$LIB_PATH/libasound.so.2" "$LIB_PATH/libasound2.so.2"
            ldconfig
        fi
    fi
}

# --- ÇALIŞTIRMA ---
install_dependencies
if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "pop" || "$OS" == "linuxmint" ]]; then
    apply_symlink_hacks
fi

echo ""
echo -e "${CYAN}📂 İndirdiğin .run dosyasını terminale sürükle ve ENTER'a bas:${RESET}"
read -r INSTALLER_PATH
INSTALLER_PATH=$(echo $INSTALLER_PATH | tr -d "'\"")

if [ -f "$INSTALLER_PATH" ]; then
    chmod +x "$INSTALLER_PATH"
    echo -e "${GREEN}🚀 Kurulum Başlatılıyor...${RESET}"
    SKIP_PACKAGE_CHECK=1 "$INSTALLER_PATH" --appimage-extract-and-run
else
    echo -e "${RED}❌ Dosya bulunamadı!${RESET}"
fi
