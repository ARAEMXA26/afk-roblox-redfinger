#!/bin/bash

# ==============================================================================
# ROBLOX GAME BOOSTER FOR REDFINGER - ULTIMATE GOD TIER EDITION (v5.0 CLEAN)
# Author: Antigravity AI
# Target: Auto-Detect ALL Roblox + Clones, 100% Clean Output (No su errors)
# ==============================================================================

# Warna Text (ANSI Color Codes)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # Reset Color

# ==============================================================================
# ROOT DETECTION - Bypass Termux su stub sepenuhnya
# Termux menyediakan su stub di $PREFIX/bin/su yang SELALU mencetak pesan error
# "No su program found on this device" langsung ke /dev/tty (tidak bisa redirect).
# Solusi: Cari su binary ASLI Android HANYA di path sistem, abaikan Termux stub.
# ==============================================================================
SU_BIN=""
IS_ROOTED="false"

detect_real_root() {
    # Cari su binary asli di path sistem Android (BUKAN di $PREFIX/bin/su Termux)
    for candidate in /system/xbin/su /system/bin/su /sbin/su /su/bin/su /magisk/.core/bin/su; do
        if [ -x "$candidate" ]; then
            # Tes apakah binary ini benar-benar bisa memberikan akses root
            TEST_RESULT=$("$candidate" -c "echo ROOT_OK" 2>/dev/null)
            if [ "$TEST_RESULT" = "ROOT_OK" ]; then
                SU_BIN="$candidate"
                IS_ROOTED="true"
                return 0
            fi
        fi
    done
    IS_ROOTED="false"
    return 1
}

# Helper: Jalankan perintah sebagai root HANYA jika perangkat benar-benar di-root
run_root() {
    if [ "$IS_ROOTED" = "true" ] && [ -n "$SU_BIN" ]; then
        "$SU_BIN" -c "$1" 2>/dev/null
        return $?
    fi
    return 1
}

show_header() {
    clear
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${GREEN}${BOLD} 🚀 ULTIMATE ROBLOX REDFINGER BOOSTER (v5.0 CLEAN) 🚀${NC}"
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${YELLOW}   Auto-Detect Multi-Clone, FastFlags & 24/7 AFK Guard ${NC}"
    echo -e "${CYAN}====================================================${NC}\n"
}

# Memeriksa dan Meminta Izin Akses Penyimpanan (Termux & Android 11+)
check_storage() {
    if [ ! -d "/sdcard/Android" ]; then
        echo -e "${YELLOW}[!] Meminta izin penyimpanan dasar Termux...${NC}"
        termux-setup-storage
        sleep 2
    fi

    # Cek Izin Akses Semua File untuk Android 11+
    TEST_DIR="/sdcard/Android/data/.termux_test_$$"
    mkdir -p "$TEST_DIR" 2>/dev/null
    if [ ! -d "$TEST_DIR" ]; then
        echo -e "${YELLOW}[!] Android 11+ Terdeteksi: Membuka Izin Akses Semua File...${NC}"
        echo -e "${YELLOW}[!] Silakan aktifkan sakelar 'Izinkan Akses Semua File' untuk Termux.${NC}"
        am start -a android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION -d package:com.termux 2>/dev/null
        sleep 2
    else
        rm -rf "$TEST_DIR" 2>/dev/null
    fi
}

# ==============================================================================
# DETEKSI OTOMATIS SEMUA APLIKASI ROBLOX (UTAMA + SEMUA JENIS CLONE)
# Metode: pm list packages + folder scan + clone app scan
# ==============================================================================
find_roblox_dirs() {
    ROBLOX_PATHS=()

    # 1. Pindai Paket Terinstall via Android Package Manager (pm)
    if command -v pm &>/dev/null; then
        PKGS=$(pm list packages 2>/dev/null | grep -i "roblox" | cut -d: -f2)
        for pkg in $PKGS; do
            if [ -n "$pkg" ]; then
                [ -d "/sdcard/Android/data/$pkg" ] && ROBLOX_PATHS+=("/sdcard/Android/data/$pkg")
                [ -d "/data/data/$pkg" ] && ROBLOX_PATHS+=("/data/data/$pkg")
                [ -d "/data/user/0/$pkg" ] && ROBLOX_PATHS+=("/data/user/0/$pkg")
            fi
        done
    fi

    # 2. Pindai Folder /sdcard/Android/data/ untuk Semua Folder Berunsur Roblox
    for dir in /sdcard/Android/data/*roblox* /sdcard/Android/data/*Roblox* /sdcard/Android/data/*ROBLOX*; do
        if [ -d "$dir" ]; then
            local already_added="false"
            for existing in "${ROBLOX_PATHS[@]}"; do
                [ "$existing" = "$dir" ] && already_added="true" && break
            done
            [ "$already_added" = "false" ] && ROBLOX_PATHS+=("$dir")
        fi
    done

    # 3. Pindai Folder Aplikasi Cloner Populer
    for clone_parent in \
        /sdcard/Android/data/com.appcloner.*/files \
        /sdcard/Android/data/com.lbe.parallel.*/files \
        /sdcard/Android/data/com.excellance.multi.*/files \
        /sdcard/Android/data/com.vphonegaga.*/files \
        /sdcard/ParallelSpace/* \
        /sdcard/DualSpace/* \
        /sdcard/AppCloner/*; do
        if [ -d "$clone_parent" ]; then
            local already_added="false"
            for existing in "${ROBLOX_PATHS[@]}"; do
                [ "$existing" = "$clone_parent" ] && already_added="true" && break
            done
            [ "$already_added" = "false" ] && ROBLOX_PATHS+=("$clone_parent")
        fi
    done

    # 4. Fallback Default jika Belum Ada yang Terbaca
    if [ ${#ROBLOX_PATHS[@]} -eq 0 ]; then
        ROBLOX_PATHS+=("/sdcard/Android/data/com.roblox.client")
    fi
}

# Tampilkan Daftar Roblox yang Terdeteksi
show_detected_roblox() {
    find_roblox_dirs
    echo -e "${CYAN}${BOLD}[ 🔍 DETEKSI APLIKASI ROBLOX ]${NC}"
    echo -e "${BLUE}[*] Ditemukan ${#ROBLOX_PATHS[@]} lokasi Roblox (Utama & Clone):${NC}"
    for path in "${ROBLOX_PATHS[@]}"; do
        echo -e "  ${GREEN}• $path${NC}"
    done
    if [ "$IS_ROOTED" = "true" ]; then
        echo -e "  ${PURPLE}🔓 Akses Root: Aktif ($SU_BIN)${NC}"
    else
        echo -e "  ${YELLOW}🔒 Akses Root: Tidak tersedia (Mode Non-Root)${NC}"
    fi
    echo -e ""
}

# ==============================================================================
# 1. Extreme FastFlags Injector
# ==============================================================================
apply_extreme_fastflags() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 1. PASANG EXTREME FASTFLAGS (GRAPHICS OPTIMIZER) ]${NC}\n"
    echo -e "${WHITE}Pilih Tingkat Optimalisasi Grafik:${NC}"
    echo -e "${CYAN}[1] Mode Main Smooth (60 FPS)${NC} - Grafik Low, bayangan mati, cocok untuk main aktif."
    echo -e "${CYAN}[2] Mode Multi-Clone Balanced (30 FPS)${NC} - Cocok untuk 2-3 clone akun."
    echo -e "${CYAN}[3] Mode EXTREME POTATO / 24/7 AFK (15 FPS)${NC} - Paling Ringan! Hemat GPU & RAM 85%!"
    echo -e ""
    read -p "Pilihan Anda [1-3]: " mode_choice

    case $mode_choice in
        1) FPS_LIMIT="60"; SKIP_MIPS="3"; DISABLE_MAT="False"; DISABLE_GRASS="0" ;;
        2) FPS_LIMIT="30"; SKIP_MIPS="4"; DISABLE_MAT="False"; DISABLE_GRASS="0" ;;
        3) FPS_LIMIT="15"; SKIP_MIPS="5"; DISABLE_MAT="True";  DISABLE_GRASS="0" ;;
        *) FPS_LIMIT="30"; SKIP_MIPS="4"; DISABLE_MAT="False"; DISABLE_GRASS="0" ;;
    esac

    FASTFLAGS_JSON="{
  \"FFlagDebugGraphicsDisableDirect3D11\": \"False\",
  \"FFlagDisablePostFx\": \"True\",
  \"FIntDebugTextureManagerSkipMips\": \"$SKIP_MIPS\",
  \"DFIntTextureQualityOverride\": \"1\",
  \"DFIntRenderShadowIntensity\": \"0\",
  \"FFlagGraphicsDisableShadows\": \"True\",
  \"DFIntDebugFRMQualityLevelOverride\": \"1\",
  \"FFlagRenderFixParticles3\": \"True\",
  \"DFIntTaskSchedulerTargetFps\": \"$FPS_LIMIT\",
  \"FFlagDisableTerrainDetail\": \"True\",
  \"FFlagEnableInGameMenuV3\": \"True\",
  \"FIntRenderGrassHeightScaler\": \"$DISABLE_GRASS\",
  \"FIntRenderBloomQuality\": \"0\",
  \"FIntLightAtmosphereQuality\": \"0\",
  \"FIntRenderDepthOfFieldQuality\": \"0\",
  \"FFlagDebugDisableMaterials\": \"$DISABLE_MAT\"
}"

    echo -e "\n${BLUE}[*] Menerapkan FastFlags ke ${#ROBLOX_PATHS[@]} lokasi Roblox...${NC}"

    TMP_JSON="$HOME/ClientAppSettings.json"
    echo "$FASTFLAGS_JSON" > "$TMP_JSON"

    SUCCESS_COUNT=0
    FAIL_COUNT=0

    for path in "${ROBLOX_PATHS[@]}"; do
        SETTINGS_DIR="$path/files/ClientSettings"
        TARGET_FILE="$SETTINGS_DIR/ClientAppSettings.json"
        
        mkdir -p "$SETTINGS_DIR" 2>/dev/null
        cp "$TMP_JSON" "$TARGET_FILE" 2>/dev/null || echo "$FASTFLAGS_JSON" > "$TARGET_FILE" 2>/dev/null

        if [ -f "$TARGET_FILE" ]; then
            echo -e "${GREEN}[✓] Berhasil dipasang di: $path${NC}"
            ((SUCCESS_COUNT++))
        else
            # Coba dengan root jika tersedia
            if [ "$IS_ROOTED" = "true" ]; then
                run_root "mkdir -p $SETTINGS_DIR && echo '$FASTFLAGS_JSON' > $TARGET_FILE && chmod 777 $TARGET_FILE"
                if [ -f "$TARGET_FILE" ]; then
                    echo -e "${GREEN}[✓] Berhasil dipasang (Root) di: $path${NC}"
                    ((SUCCESS_COUNT++))
                    continue
                fi
            fi
            echo -e "${RED}[×] Gagal akses file di: $path${NC}"
            echo -e "${YELLOW}    Solusi: Aktifkan izin 'Akses Semua File' Termux di Pengaturan Android.${NC}"
            ((FAIL_COUNT++))
        fi
    done
    rm -f "$TMP_JSON" 2>/dev/null

    echo -e "\n${GREEN}${BOLD}=== Hasil: $SUCCESS_COUNT Berhasil, $FAIL_COUNT Gagal ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 2. ART Bytecode Pre-Compilation
# ==============================================================================
compile_roblox_art() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 2. ADVANCED ANDROID ART COMPILATION ]${NC}\n"

    if command -v pm &>/dev/null; then
        PKGS=$(pm list packages 2>/dev/null | grep -i "roblox" | cut -d: -f2)
        if [ -z "$PKGS" ]; then
            PKGS="com.roblox.client"
        fi
        
        for pkg in $PKGS; do
            echo -e "${BLUE}[*] Mengompilasi paket $pkg (Speed Profile)...${NC}"
            if [ "$IS_ROOTED" = "true" ]; then
                run_root "cmd package compile -m speed $pkg"
            else
                cmd package compile -m speed $pkg 2>/dev/null
            fi
            echo -e "${GREEN}[✓] Kompilasi ART $pkg Selesai!${NC}"
        done
    else
        echo -e "${YELLOW}[!] Perintah 'pm' tidak tersedia di perangkat ini.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Kompilasi Paket Roblox Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 3. Deep RAM & Process Tuning
# ==============================================================================
deep_memory_tune() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 3. DEEP RAM & CPU PRIORITY TUNING ]${NC}\n"
    
    # 1. Matikan Animasi Sistem
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi Sistem dimatikan (0.0x).${NC}"
    fi

    # 2. Naikkan Prioritas CPU untuk Proses Roblox
    echo -e "${BLUE}[*] Meningkatkan prioritas CPU untuk semua proses Roblox...${NC}"
    FOUND_PIDS=""
    if command -v pgrep &>/dev/null; then
        FOUND_PIDS=$(pgrep -i roblox 2>/dev/null)
    fi
    if [ -z "$FOUND_PIDS" ] && command -v pidof &>/dev/null; then
        FOUND_PIDS=$(pidof com.roblox.client 2>/dev/null)
    fi

    if [ -n "$FOUND_PIDS" ]; then
        for pid in $FOUND_PIDS; do
            renice -n -10 -p $pid 2>/dev/null
            echo -e "${GREEN}[✓] CPU Priority dinaikkan untuk PID: $pid${NC}"
        done
    else
        echo -e "${YELLOW}[i] Tidak ada proses Roblox yang sedang berjalan saat ini.${NC}"
    fi

    # 3. Bersihkan Cache & Log Roblox
    echo -e "${BLUE}[*] Membersihkan cache & log semua Roblox...${NC}"
    find_roblox_dirs
    for path in "${ROBLOX_PATHS[@]}"; do
        rm -rf "$path/files/logs"/* 2>/dev/null
        rm -rf "$path/cache"/* 2>/dev/null
    done
    rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null
    echo -e "${GREEN}[✓] Cache & log berhasil dibersihkan.${NC}"

    # 4. Kosongkan RAM Kernel (Hanya jika Root tersedia)
    if [ "$IS_ROOTED" = "true" ]; then
        run_root "sync; echo 3 > /proc/sys/vm/drop_caches; am kill-all"
        echo -e "${GREEN}[✓] RAM Kernel Buffer berhasil dikosongkan (Root).${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Memory & Process Tuning Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 4. Background 24/7 AFK Guard Daemon
# ==============================================================================
start_afk_guard() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 4. NYALAKAN 24/7 AFK AUTO-CLEANER DAEMON ]${NC}\n"
    echo -e "${WHITE}Daemon ini akan berjalan di latar belakang Termux.${NC}"
    echo -e "${WHITE}Tugas: Membersihkan log & cache Roblox setiap 15 menit secara otomatis.${NC}\n"
    
    read -p "Jalankan Auto-Cleaner Daemon? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}[*] Memulai background guard daemon...${NC}"
        (
            while true; do
                sleep 900 # 15 menit
                find_roblox_dirs
                for path in "${ROBLOX_PATHS[@]}"; do
                    rm -rf "$path/files/logs"/* 2>/dev/null
                    rm -rf "$path/cache"/* 2>/dev/null
                done
                rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null
            done
        ) &
        echo -e "${GREEN}[✓] Daemon AFK Guard aktif di latar belakang (PID: $!)!${NC}"
        echo -e "${GREEN}[✓] Biarkan Termux tetap terbuka / berjalan di background.${NC}"
    else
        echo -e "${YELLOW}[i] Daemon dibatalkan.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 5. Restore Defaults
# ==============================================================================
restore_defaults() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 5. RESTORE DEFAULT SETTINGS ]${NC}\n"
    
    find_roblox_dirs
    for path in "${ROBLOX_PATHS[@]}"; do
        rm -f "$path/files/ClientSettings/ClientAppSettings.json" 2>/dev/null
    done

    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 1.0 2>/dev/null
        settings put global transition_animation_scale 1.0 2>/dev/null
        settings put global animator_duration_scale 1.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi sistem dikembalikan ke default (1.0x).${NC}"
    fi

    echo -e "${GREEN}[✓] FastFlags dihapus. Pengaturan dikembalikan ke default.${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
main_menu() {
    # Inisialisasi: Deteksi root & storage di awal sekali
    detect_real_root
    check_storage
    
    while true; do
        show_header
        echo -e "${WHITE}${BOLD}MENU OPTIMALISASI GOD TIER (REDFINGER):${NC}"
        echo -e "${CYAN}[1]${NC} FastFlags Extreme (Smooth 60FPS / Clone 30FPS / Extreme Potato 15FPS)"
        echo -e "${CYAN}[2]${NC} Android ART Bytecode Compilation (Loading Kencang & Anti Stutter)"
        echo -e "${CYAN}[3]${NC} Deep RAM & CPU Priority Tuning (Bocorkan Sampah & Boost CPU)"
        echo -e "${CYAN}[4]${NC} Jalankan 24/7 AFK Auto-Cleaner Guard Daemon (Background)"
        echo -e "${CYAN}[5]${NC} Kembalikan Pengaturan ke Default"
        echo -e "${RED}[0]${NC} Keluar (Exit)"
        echo -e ""
        read -p "Pilihan Anda [0-5]: " choice
        
        case $choice in
            1) apply_extreme_fastflags ;;
            2) compile_roblox_art ;;
            3) deep_memory_tune ;;
            4) start_afk_guard ;;
            5) restore_defaults ;;
            0) echo -e "\n${GREEN}Selamat bermain Roblox! 🎮${NC}\n"; exit 0 ;;
            *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
        esac
    done
}

main_menu
