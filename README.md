# 🚀 AFK Roblox Redfinger Game Booster & Multi-Clone Optimizer (v6.0 Final)

![Redfinger](https://img.shields.io/badge/Platform-Redfinger%20Cloud%20Android-blue)
![Termux](https://img.shields.io/badge/Tool-Termux-green)
![Roblox](https://img.shields.io/badge/Game-Roblox-red)
![Android](https://img.shields.io/badge/Android-11%2B%20Supported-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)

Script optimalisasi khusus **Android / Redfinger Cloud Phone** untuk membuat aplikasi Roblox (Original & Hasil Clone / Multi-Account) menjadi **super ringan, anti-lag, dan lancar untuk AFK Farming 24/7**.

> ✅ **Mendukung Android 11+** — Script otomatis mendeteksi pembatasan izin dan menyediakan panduan pemasangan manual jika diperlukan.

---

## ⚡ Perintah Instan Termux (One-Line Execution)

Buka aplikasi **Termux** di Redfinger Anda, lalu salin dan tempel perintah berikut:

```bash
pkg update && pkg install -y curl bash && bash <(curl -sL https://raw.githubusercontent.com/ARAEMXA26/afk-roblox-redfinger/main/roblox_booster.sh)
```

---

## ✨ Fitur-Fitur Utama

### 1. 🥔 Extreme FastFlags & Potato Mode (Hemat GPU & VRAM s/d 85%)
- **3 Mode Grafik**: Smooth 60 FPS, Clone 30 FPS, atau Extreme Potato 15 FPS.
- Mematikan bayangan, bloom, atmosfer, rumput, dan efek post-processing.
- Menurunkan kualitas tekstur ke level terendah.

### 2. 📱 Auto-Detect Roblox Original & Semua App Clone
- Otomatis memindai paket terinstall via `pm list packages`.
- Mendukung App Cloner, Parallel Space, Dual Space, dan lainnya.

### 3. 🔒 Kompatibel Android 11+ (Non-Root)
- Jika pemasangan otomatis gagal karena pembatasan Android 11+, script akan:
  - Menyimpan file FastFlags ke `/sdcard/Download/RobloxBooster/`
  - Menampilkan panduan langkah demi langkah untuk copy manual via File Manager
  - Mencoba membuka File Manager secara otomatis

### 4. ⚡ Android ART Bytecode Pre-Compilation
- Mengompilasi kode Roblox secara native untuk mengurangi stuttering dan mempercepat loading.

### 5. 🛡️ 24/7 AFK Auto-Cleaner Guard Daemon
- Background process yang membersihkan cache setiap 15 menit agar Redfinger tidak lag saat AFK seharian.

---

## 📖 Cara Penggunaan

### Cara 1: One-Line (Langsung Jalankan Online)
```bash
pkg update && pkg install -y curl bash && bash <(curl -sL https://raw.githubusercontent.com/ARAEMXA26/afk-roblox-redfinger/main/roblox_booster.sh)
```

### Cara 2: Download Dulu ke Termux
```bash
termux-setup-storage
curl -O https://raw.githubusercontent.com/ARAEMXA26/afk-roblox-redfinger/main/roblox_booster.sh
chmod +x roblox_booster.sh
./roblox_booster.sh
```

---

## 🎮 Tampilan Menu

```text
====================================================
 🚀 ULTIMATE ROBLOX REDFINGER BOOSTER (v6.0 FINAL) 🚀
====================================================

MENU OPTIMALISASI (REDFINGER):
[1] FastFlags Extreme (60FPS / 30FPS Clone / 15FPS AFK Potato)
[2] Android ART Compilation (Loading Kencang & Anti Stutter)
[3] Deep RAM & CPU Priority Tuning
[4] 24/7 AFK Auto-Cleaner Guard Daemon
[5] Kembalikan Pengaturan ke Default
[0] Keluar
```

---

## 📝 Panduan Manual untuk Android 11+ (Jika Otomatis Gagal)

Jika muncul pesan `[!] Tidak bisa dipasang otomatis (Pembatasan Android 11+)`:

1. File sudah disimpan di: `/sdcard/Download/RobloxBooster/ClientAppSettings.json`
2. Buka **File Manager** (MT Manager / ZArchiver / bawaan)
3. Copy file `ClientAppSettings.json`
4. Buka folder: `/sdcard/Android/data/com.roblox.client/files/ClientSettings/`
   - Jika folder `ClientSettings` belum ada, buat manual
5. Paste file di sana
6. **Force Close** dan buka ulang Roblox

---

## 📄 Lisensi
MIT License. Created with ❤️ for Roblox Redfinger AFK Farmers.
