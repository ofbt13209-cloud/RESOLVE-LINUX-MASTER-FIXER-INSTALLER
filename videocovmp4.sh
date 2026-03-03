#!/bin/bash

# En az bir argüman girildiğinden emin ol
if [ "$#" -lt 1 ]; then
    echo "Kullanım: $0 <dosya1> <dosya2> ..."
    exit 1
fi

# Aynı anda dönüştürülecek maksimum video sayısı
# İşlemci çekirdek sayına göre ayarlayabilirsin (örneğin: 2, 4 veya 8)
MAX_JOBS=4

# Dönüştürme işlemini bir fonksiyon haline getiriyoruz
convert_to_mp4() {
    input_file="$1"

    # Dosya adını ve uzantısını ayır
    input_file_name=$(basename "$input_file")
    input_file_name="${input_file_name%.*}"

    # Çıktı dosya adını belirle
    output_mp4="${input_file_name}-converted.mp4"

    echo "[BAŞLADI] $input_file -> $output_mp4"

    # Bağımsız FFmpeg motoru ile MP4 dönüşümü
    # Eklenen -y parametresi var olan dosyanın üzerine sorusuz yazar, </dev/null kısımları ekran karmaşasını önler.
    /home/lvonx/.local/bin/ffmpeg -y -i "$input_file" -c:v libx264 -crf 23 -preset fast -pix_fmt yuv420p -c:a aac -b:a 192k "$output_mp4" </dev/null >/dev/null 2>&1

    echo "[BİTTİ] $output_mp4"
}

# Fonksiyonu paralel çalışabilmesi için dışa aktarıyoruz
export -f convert_to_mp4

echo "Toplam $# dosya bulundu. $MAX_JOBS video eşzamanlı olarak MP4'e dönüştürülecek..."

# Tüm argümanları xargs ile paralel olarak işleme sok
printf "%s\n" "$@" | xargs -n 1 -P "$MAX_JOBS" -I {} bash -c 'convert_to_mp4 "{}"'

echo "Tüm dönüştürme işlemleri başarıyla tamamlandı!"
