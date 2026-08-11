# 🚀 Roblox Redfinger Game Booster & Multi-Clone Optimizer (v7.0)

![Redfinger](https://img.shields.io/badge/Platform-Redfinger%20Cloud%20Android-blue)
![Termux](https://img.shields.io/badge/Tool-Termux-green)
![Roblox](https://img.shields.io/badge/Game-Roblox-red)
![Android](https://img.shields.io/badge/Android-11%2B%20Compatible-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Version](https://img.shields.io/badge/Version-7.0%20Final-brightgreen)

Script Termux untuk mengoptimalkan **Roblox di Redfinger Cloud Android** agar super ringan, anti-lag, dan lancar untuk **AFK Farming 24/7 nonstop**. Mendukung Roblox Original & semua App Clone.

> ✅ **Kompatibel Android 11+** — Tidak ada error `Permission denied` atau `No su program found`. Semua menu berfungsi dengan bersih.

---

## ⚡ Cara Pakai (1 Perintah)

Buka **Termux** di Redfinger, salin & tempel perintah ini:

```bash
pkg update && pkg install -y curl bash && bash <(curl -sL https://raw.githubusercontent.com/ARAEMXA26/afk-roblox-redfinger/main/roblox_booster.sh)
```

Atau download dulu ke Termux:

```bash
termux-setup-storage
curl -O https://raw.githubusercontent.com/ARAEMXA26/afk-roblox-redfinger/main/roblox_booster.sh
chmod +x roblox_booster.sh
./roblox_booster.sh
```

---

## 🎮 Menu Utama

```text
======================================================
  🚀 ROBLOX REDFINGER GAME BOOSTER v7.0 (FINAL) 🚀
======================================================

PILIH MENU OPTIMASI:

  [1] Pasang FastFlags (Low Graphics & FPS Booster)
  [2] ART Compilation (Loading Cepat & Anti Stutter)
  [3] RAM & CPU Tuning (Matikan Animasi & Boost CPU)
  [4] AFK 24/7 Auto-Cleaner Daemon
  [5] Kembalikan ke Default (Restore)
  [6] ⚡ BOOST SEMUA SEKALIGUS (1 Klik)
  [0] Keluar
```

---

## ✨ Penjelasan Setiap Menu

### Menu [1] — Pasang FastFlags (Low Graphics & FPS Booster)
Menyuntikkan konfigurasi `ClientAppSettings.json` ke Roblox untuk menurunkan grafik.

| Sub-Pilihan | FPS | Efek |
|---|---|---|
| **Mode 1: Smooth** | 60 FPS | Grafik Low, bayangan mati. Cocok main aktif. |
| **Mode 2: Clone Balanced** | 30 FPS | Hemat CPU untuk 2-3 clone akun. |
| **Mode 3: Extreme Potato** | 15 FPS | Tanpa rumput, material polos, tanpa bloom. Hemat 85% GPU. |

**Cara kerja di Android 11+ (Non-Root):**
1. Script menyimpan file ke `/sdcard/Download/RobloxBooster/`
2. File Manager terbuka otomatis
3. Anda tinggal copy `ClientAppSettings.json` ke `Android/data/com.roblox.client/files/ClientSettings/`
4. Force Close Roblox → Selesai!

---

### Menu [2] — ART Bytecode Compilation
Mengompilasi kode aplikasi Roblox secara native di Android agar:
- Loading game lebih cepat
- Stuttering (patah-patah) berkurang
- CPU lebih efisien

---

### Menu [3] — RAM & CPU Tuning
- ✅ Mematikan animasi sistem Android (jendela, transisi, animator → 0.0x)
- ✅ Menaikkan prioritas CPU untuk proses Roblox yang sedang berjalan
- ✅ Membersihkan cache & file log sampah
- ✅ Menutup aplikasi background berat (Maps, Chrome, GMS)

---

### Menu [4] — AFK 24/7 Auto-Cleaner Daemon
Menjalankan proses pembersih otomatis di latar belakang Termux:
- Interval: Setiap **15 menit**
- Membersihkan cache & log yang menumpuk
- Mencegah Redfinger lag / crash saat ditinggal AFK seharian
- Otomatis menghentikan daemon lama jika sudah ada yang berjalan

---

### Menu [5] — Restore Default
- Menghapus semua file FastFlags
- Mengembalikan animasi sistem ke 1.0x (default)
- Menghentikan AFK Daemon

---

### Menu [6] — ⚡ Boost Semua Sekaligus (1 Klik)
Menjalankan **semua optimasi** secara berurutan dalam 1 kali klik:
1. FastFlags Extreme Potato (15 FPS AFK)
2. ART Compilation
3. RAM & CPU Tuning
4. AFK Daemon

Cocok untuk setup cepat sebelum AFK farming.

---

## 📝 Catatan untuk Android 11+ Non-Root

Mulai Android 11, semua aplikasi (termasuk Termux) **tidak bisa** menulis langsung ke folder `/sdcard/Android/data/<app_lain>/`. Ini adalah pembatasan keamanan Google di level kernel.

**Tapi File Manager bawaan Android BISA mengakses folder tersebut.** Maka untuk Menu [1] FastFlags:

1. Script otomatis menyimpan file ke `/sdcard/Download/RobloxBooster/`
2. Script otomatis membuka File Manager
3. Anda **copy** file `ClientAppSettings.json` dari `Download/RobloxBooster/`
4. **Paste** ke `Android/data/com.roblox.client/files/ClientSettings/`
5. Jika folder `ClientSettings` belum ada, buat manual
6. **Force Close** Roblox dan buka ulang

> 💡 **Tips**: Instal **MT Manager** dari Play Store untuk file manager yang lebih mudah mengakses folder `Android/data/`.

---

## 📄 Lisensi

MIT License. Created with ❤️ for Roblox Redfinger AFK Farmers.
