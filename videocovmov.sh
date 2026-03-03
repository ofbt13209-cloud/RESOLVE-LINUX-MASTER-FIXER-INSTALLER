#!/bin/bash

# En az bir argüman girildiğinden emin ol
if [ "$#" -lt 1 ]; then
    echo "Kullanım: $0 <dosya1> <dosya2> ..."
    exit 1
fi

# Aynı anda dönüştürülecek maksimum video sayısı
# DNxHR dönüşümü diski ve işlemciyi çok kullanır, çok zorlanırsan bunu 2 yapabilirsin.
MAX_JOBS=4

# Dönüştürme işlemini bir fonksiyon haline getiriyoruz
convert_to_mov() {
    input_file="$1"
    input_file_name=$(basename "$input_file")
    input_file_name="${input_file_name%.*}"
    output_mov="${input_file_name}-converted.mov"

    echo "[BAŞLADI] $input_file -> $output_mov"

    # DaVinci Resolve'un en sevdiği format: DNxHR HQ codec, YUV422p renk ve PCM 16-bit ses
    # Dosya yolu silinip sadece "ffmpeg" yapıldı (Global kullanım için)
    ffmpeg -y -i "$input_file" -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le -f mov "$output_mov" </dev/null >/dev/null 2>&1

    echo "[BİTTİ] $output_mov"
}

# Fonksiyonu dışa aktarıyoruz
export -f convert_to_mov

echo "Toplam $# dosya bulundu."
echo "DaVinci Resolve için özel DNxHR formatında $MAX_JOBS video eşzamanlı dönüştürülecek..."
echo "------------------------------------------------------------"

# Tüm dosyaları xargs'e gönderip paralel (-P) olarak işliyoruz
printf "%s\n" "$@" | xargs -n 1 -P "$MAX_JOBS" -I {} bash -c 'convert_to_mov "{}"'

echo "------------------------------------------------------------"
echo "✅ Tüm MOV dönüştürme işlemleri başarıyla tamamlandı!"
