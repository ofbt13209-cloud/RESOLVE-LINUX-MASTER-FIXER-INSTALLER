#!/bin/bash

# Renkler
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}##################################################${NC}"
echo -e "${BLUE}#      DAVINCI RESOLVE KÜTÜPHANE TAMİR ARACI     #${NC}"
echo -e "${BLUE}##################################################${NC}"

# Root kontrolü
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Lütfen yönetici olarak çalıştırın: sudo ./davinci_fix.sh${NC}"
  exit
fi

echo -e "${BLUE}1. Adım: Eksik sistem paketleri yükleniyor...${NC}"
# Hem eski hem yeni (t64) paket isimlerini dener
apt update
apt install -y libapr1 libaprutil1 libglib2.0-0 libxcb-composite0 \
libxcb-cursor0 libxcb-xinerama0 libxcb-xinput0 libxcb-icccm4 \
libxcb-render-util0 libxcb-shape0 libxkbcommon-x11-0 \
libasound2 libasound2t64 2>/dev/null

echo -e "${GREEN}✅ Paket kurulumu tamamlandı (veya zaten yüklü).${NC}"

echo -e "${BLUE}2. Adım: Çakışan 'glib' kütüphaneleri temizleniyor...${NC}"
# DaVinci'nin kendi eski kütüphaneleri sistemle çakışıyor, onları saklıyoruz.

RESOLVE_LIBS="/opt/resolve/libs"
BACKUP_DIR="$RESOLVE_LIBS/disabled-libraries"

# Yedek klasörü oluştur
mkdir -p "$BACKUP_DIR"

# Sorunlu dosyaları taşı
mv -v "$RESOLVE_LIBS"/libglib-2.0.so* "$BACKUP_DIR"/ 2>/dev/null
mv -v "$RESOLVE_LIBS"/libgio-2.0.so* "$BACKUP_DIR"/ 2>/dev/null
mv -v "$RESOLVE_LIBS"/libgmodule-2.0.so* "$BACKUP_DIR"/ 2>/dev/null
mv -v "$RESOLVE_LIBS"/libonig.so* "$BACKUP_DIR"/ 2>/dev/null

echo -e "${GREEN}✅ Çakışan dosyalar '$BACKUP_DIR' içine taşındı.${NC}"

echo -e "${BLUE}3. Adım: Sembolik Bağlar Kontrol Ediliyor...${NC}"
# libasound2 hatası için yama
if [ -f /usr/lib/x86_64-linux-gnu/libasound.so.2 ] && [ ! -f /usr/lib/x86_64-linux-gnu/libasound2.so.2 ]; then
    ln -s /usr/lib/x86_64-linux-gnu/libasound.so.2 /usr/lib/x86_64-linux-gnu/libasound2.so.2
    echo "🔗 libasound2 bağı oluşturuldu."
fi

ldconfig
echo -e "${GREEN}🎉 İŞLEM TAMAM! DaVinci Resolve'u açmayı deneyebilirsin.${NC}"
