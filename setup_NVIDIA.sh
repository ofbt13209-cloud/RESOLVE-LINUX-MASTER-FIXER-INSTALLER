#!/bin/bash

# --- RENKLER VE GÖRSELLEŞTİRME ---
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${CYAN}#############################################################${RESET}"
echo -e "${CYAN}#     DAVINCI RESOLVE UNIVERSAL LINUX INSTALLER (ULTIMATE)  #${RESET}"
echo -e "${CYAN}#       (Ubuntu 24.04+ / Fedora / Arch / Debian Uyumlu)     #${RESET}"
echo -e "${CYAN}#############################################################${RESET}"

# 1. ROOT KONTROLÜ
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ HATA: Bu script yönetici yetkisi gerektirir.${RESET}"
  echo -e "Lütfen şöyle çalıştırın: ${BOLD}sudo ./setup.sh${RESET}"
  exit
fi

# 2. SİSTEM TESPİTİ
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
    echo -e "${GREEN}✅ Sistem Tespit Edildi: ${BOLD}${NAME} (${VERSION_ID})${RESET}"
else
    echo -e "${RED}❌ Dağıtım bilgisi okunamadı!${RESET}"
    exit 1
fi

# 3. BAĞIMLILIK VE HACK FONKSİYONLARI
install_dependencies() {
    echo -e "${BLUE}🔧 Sistem bağımlılıkları analiz ediliyor...${RESET}"
    
    case $OS in
        ubuntu|debian|linuxmint|pop|kali|neon)
            apt update
            
            # --- UBUNTU 24.04 / DEBIAN 13 ÖZEL ÇÖZÜMÜ (t64 Geçişi) ---
            # Yeni sistemlerde paketlerin sonuna 't64' eklendi, DaVinci bunu bilmiyor.
            # Bu blok hem eski hem yeni paketleri dener.
            
            PKGS="libapr1 libaprutil1 libglib2.0-0 libxcb-composite0 libxcb-cursor0 \
            libxcb-xinerama0 libxcb-xinput0 libxcb-icccm4 libxcb-render-util0 \
            libxcb-shape0 libxkbcommon-x11-0 libnvidia-encode-any nvidia-cuda-toolkit"
            
            # libasound2 sorunu için akıllı kontrol
            if apt-cache show libasound2 >/dev/null 2>&1; then
                PKGS="$PKGS libasound2"
            else
                echo -e "${YELLOW}⚠️  Eski 'libasound2' bulunamadı (Modern sistem). 'libasound2t64' kuruluyor...${RESET}"
                PKGS="$PKGS libasound2t64"
                NEEDS_SYMLINK_ASOUND=true
            fi

             # libapr sorunu için akıllı kontrol
            if ! apt-cache show libapr1 >/dev/null 2>&1; then
                 PKGS="$PKGS libapr1t64 libaprutil1t64"
                 NEEDS_SYMLINK_APR=true
            fi

            apt install -y $PKGS
            ;;
        
        fedora|nobara)
            echo -e "${BLUE}📦 Fedora/Nobara paketleri kuruluyor...${RESET}"
            dnf install -y apr apr-util alsa-lib mesa-libGLU libxcb libX11 libXext libXfixes \
            libXi libXrender libXcursor libXinerama libxkbcommon-x11 xorg-x11-drv-nvidia-cuda
            ;;
            
        arch|manjaro|endeavouros)
            echo -e "${BLUE}📦 Arch Linux paketleri kuruluyor...${RESET}"
            pacman -S --needed --noconfirm base-devel apr apr-util alsa-lib mesa-libglu \
            libxcb libx11 libxext libxfixes libxi libxrender libxcursor libxinerama \
            libxkbcommon-x11 nvidia-utils opencl-nvidia
            ;;
    esac
}

# 4. SYMLINK HACK (Ubuntu 24.04+ İÇİN KRİTİK BÖLÜM)
apply_symlink_hacks() {
    echo -e "${BLUE}🔗 Uyumluluk köprüleri (Symlinks) kontrol ediliyor...${RESET}"
    
    # Debian/Ubuntu tabanlılarda kütüphane yolu genelde burasıdır
    LIB_PATH="/usr/lib/x86_64-linux-gnu"
    
    if [ "$NEEDS_SYMLINK_ASOUND" = true ]; then
        if [ -f "$LIB_PATH/libasound.so.2" ] && [ ! -f "$LIB_PATH/libasound2.so.2" ]; then
            echo -e "${YELLOW}🛠️  FIX: libasound2t64 -> libasound2 maskelemesi yapılıyor...${RESET}"
            ln -s "$LIB_PATH/libasound.so.2" "$LIB_PATH/libasound2.so.2"
        fi
    fi
    
    # DaVinci bazen libglib-2.0-0 ister ama sistemde libglib-2.0 vardır
    if [ -f "$LIB_PATH/libglib-2.0.so.0" ] && [ ! -f "$LIB_PATH/libglib-2.0-0.so.0" ]; then
         echo -e "${YELLOW}🛠️  FIX: GLib isimlendirmesi düzeltiliyor...${RESET}"
         ln -s "$LIB_PATH/libglib-2.0.so.0" "$LIB_PATH/libglib-2.0-0.so.0"
    fi
    
    # Sistem kütüphanelerini yenile
    ldconfig
    echo -e "${GREEN}✅ Kütüphane yolları yamalandı.${RESET}"
}

# --- İŞLEM BAŞLIYOR ---

install_dependencies
if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "pop" || "$OS" == "linuxmint" ]]; then
    apply_symlink_hacks
fi

echo ""
echo -e "${CYAN}📂 Lütfen indirdiğin .run dosyasını terminale sürükle ve ENTER'a bas:${RESET}"
read -r INSTALLER_PATH
INSTALLER_PATH=$(echo $INSTALLER_PATH | tr -d "'\"")

if [ -f "$INSTALLER_PATH" ]; then
    echo -e "${GREEN}🚀 DaVinci Resolve Yükleyici Başlatılıyor...${RESET}"
    echo -e "${YELLOW}Bilgi: Kurulum sihirbazı açılacak. Hata verirse bile 'İlerle' butonları aktifse devam et.${RESET}"
    
    chmod +x "$INSTALLER_PATH"
    
    # --appimage-extract-and-run ile paket kontrolünü bypass etmeye çalışıyoruz
    # SKIP_PACKAGE_CHECK=1 değişkeni bazı versiyonlarda kontrolü atlar
    SKIP_PACKAGE_CHECK=1 "$INSTALLER_PATH" --appimage-extract-and-run
else
    echo -e "${RED}❌ Dosya bulunamadı!${RESET}"
fi

echo -e "${GREEN}🏁 Script görevini tamamladı.${RESET}"
echo -e "${YELLOW}Eğer kurulum başarılı olursa, programı açmadan önce mutlaka RESTART at.${RESET}"
