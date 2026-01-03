# 🎥 DAVINCI RESOLVE LINUX MASTER FIXER & INSTALLER 🚀

![Linux Support](https://img.shields.io/badge/Support-Ubuntu%20%7C%20Fedora%20%2C%20Arch-blueviolet?style=for-the-badge&logo=linux)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## 🌍 Language / Dil
- [🇹🇷 Türkçe İçerik](#-türkçe-readme---tr)
- [🇺🇸 English Content](#-english-readme---en)

---

## 🇹🇷 TÜRKÇE (README - TR)

Bu araç seti, Linux sistemlerde (Ubuntu, Fedora, Arch) DaVinci Resolve kurulumunu ve kütüphane çakışmalarını **OTOMATİK OLARAK ÇÖZER**. 🛠️

> [!IMPORTANT]
> **ÖNEMLİ NOT:** Bu projenin temel ve en kritik dosyaları `setup.sh` ve `fix_resolve.sh` dosyalarıdır. Diğer tüm araçlar (çeviriciler vb.) tamamen **opsiyoneldir**, ihtiyaca göre kullanılabilir.

### 🛠️ İÇERİK
| Dosya | Açıklama |
| :--- | :--- |
| 📦 **setup.sh** | Sistem bağımlılıklarını **KURAR** ve yükleyiciyi **BAŞLATIR**. |
| 🔧 **fix_resolve.sh** | Kurulum sonrası **AÇILMAMA** sorunlarını **GİDERİR**. |
| 🎞️ **videocovmov.sh** | MP4 dosyalarını kurgu için **MOV** formatına çevirir (Opsiyonel). |
| 📤 **mov_to_mp4.sh** | Kurgu bitince dosyayı **MP4** olarak export eder (Opsiyonel). |

### 🐧 DİĞER DAĞITIMLAR
UBUNTU/DEBIAN dışındaki sistemlerde `setup.sh` içindeki komutu güncelleyin:
* 🟥 **ARCH:** `pacman -S`
* 🟩 **FEDORA:** `dnf install`

> [!TIP]
> ### 🤖 GELECEK İÇİN GÜNCELLEME
> Eğer yıllar sonra bu scriptler çalışmazsa, herhangi bir **YAPAY ZEKAYA** şu cümleyi yazarak güncelletin:
> *"BU DAVINCI RESOLVE KURULUM SCRIPTINI GÜNCEL LINUX ÇEKİRDEĞİNE VE PAKET İSİMLERİNE GÖRE MODERNIZE EDER MISIN?"* 💡

### ⚠️ KRİTİK NOTLAR
* 🔌 **GPU:** Mutlaka **GÜNCEL NVIDIA** sürücülerini kullanın.
* 🖥️ **XORG:** Açılmazsa giriş ekranında **"UBUNTU ON XORG"** seçin.
* 🎬 **CODEC:** Ücretsiz sürümde H.264 videolar için **TRANSCODE** gerekebilir.

---

## 🇺🇸 ENGLISH (README - EN)

This toolkit **AUTOMATICALLY RESOLVES** DaVinci Resolve installation issues and library conflicts on Linux systems. 🛠️

> [!IMPORTANT]
> **NOTE:** The core and most critical files of this project are `setup.sh` and `fix_resolve.sh`. All other tools (converters, etc.) are completely **optional** and can be used as needed.

### 🛠️ CONTENT
* 📦 **setup.sh**: Installs system dependencies and **TRIGGERS** the installer.
* 🔧 **fix_resolve.sh**: Fixes post-installation **LAUNCH ISSUES**.
* 🎞️ **videocovmov.sh**: Transcodes MP4 to **MOV** for editing (Optional).
* 📤 **mov_to_mp4.sh**: Converts edited files back to **MP4** for export (Optional).

### 🐧 OTHER DISTRIBUTIONS
* 🟥 **ARCH:** Replace install command with `pacman -S`
* 🟩 **FEDORA:** Replace install command with `dnf install`

> [!TIP]
> ### 🤖 FOR FUTURE UPDATES
> If these scripts stop working, ask any **AI**:
> *"CAN YOU MODERNIZE THIS DAVINCI RESOLVE INSTALLATION SCRIPT ACCORDING TO THE CURRENT LINUX KERNEL AND PACKAGE NAMES?"* 💡

### ⚠️ CRITICAL TIPS
1. 🔌 **GPU:** Ensure you are using the latest proprietary **NVIDIA** drivers.
2. 🖥️ **XORG:** If it doesn't launch, switch to **"UBUNTU ON XORG"** at login.
3. 🎬 **CODEC:** Free version may require transcoding to **MOV/PRORES**.

---
*Created with ❤️ for the Linux Community by a Professional Video Editor*
