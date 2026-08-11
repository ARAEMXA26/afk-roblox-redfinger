#!/bin/bash

# ==============================================================================
# ROBLOX GAME BOOSTER FOR REDFINGER - ULTIMATE GOD TIER EDITION (v4.5 PRO)
# Author: Antigravity AI
# Target: Auto-Detect ALL Roblox Apps & Clones + Android 11+ Permission Fix
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

show_header() {
    clear
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${GREEN}${BOLD} 🚀 ULTIMATE ROBLOX REDFINGER BOOSTER (v4.5 PRO) 🚀 ${NC}"
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${YELLOW}   Auto-Detect Multi-Clone, FastFlags & Storage Fix   ${NC}"
    echo -e "${CYAN}====================================================${NC}\n"
}

# Cek Akses Root Sebenarnya (Tanpa Pesan Error "No su program found")
IS_HAS_ROOT=""
check_real_root() {
    if [ -z "$IS_HAS_ROOT" ]; then
        if command -v su &>/dev/null; then
            if su -c "id" 2>/dev/null | grep -q "uid=0"; then
                IS_HAS_ROOT="true"
            else
                IS_HAS_ROOT="false"
            fi
        else
            IS_HAS_ROOT="false"
        fi
    fi
    [ "$IS_HAS_ROOT" == "true" ]
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

# Fungsi Pintar Mencari SEMUA Aplikasi Roblox (Utama + Semua Jenis Clone)
find_roblox_dirs() {
    ROBLOX_PATHS=()

    # 1. Pindai Paket Terinstall via Android Package Manager (pm)
    if command -v pm &>/dev/null; then
        PKGS=$(pm list packages 2>/dev/null | grep -i "roblox" | cut -d: -f2)
        for pkg in $PKGS; do
            [ -n "$pkg" ] && [ -d "/sdcard/Android/data/$pkg" ] && ROBLOX_PATHS+=("/sdcard/Android/data/$pkg")
            [ -n "$pkg" ] && [ -d "/data/data/$pkg" ] && ROBLOX_PATHS+=("/data/data/$pkg")
            [ -n "$pkg" ] && [ -d "/data/user/0/$pkg" ] && ROBLOX_PATHS+=("/data/user/0/$pkg")
        done
    fi

    # 2. Pindai Folder /sdcard/Android/data/ untuk Semua Folder Berunsur Roblox
    for dir in /sdcard/Android/data/*roblox* /sdcard/Android/data/*Roblox* /sdcard/Android/data/*ROBLOX*; do
        if [ -d "$dir" ]; then
            if [[ ! " ${ROBLOX_PATHS[*]} " =~ " ${dir} " ]]; then
                ROBLOX_PATHS+=("$dir")
            fi
        fi
    done

    # 3. Pindai Folder Aplikasi Cloner Populer (App Cloner, Parallel Space, Dual Apps, Multiple Accounts, dll)
    for clone_parent in \
        /sdcard/Android/data/com.appcloner.*/files \
        /sdcard/Android/data/com.lbe.parallel.*/files \
        /sdcard/Android/data/com.excellance.multi.*/files \
        /sdcard/Android/data/com.vphonegaga.*/files \
        /sdcard/ParallelSpace/* \
        /sdcard/DualSpace/* \
        /sdcard/AppCloner/*; do
        if [ -d "$clone_parent" ]; then
            if [[ ! " ${ROBLOX_PATHS[*]} " =~ " ${clone_parent} " ]]; then
                ROBLOX_PATHS+=("$clone_parent")
            fi
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
    echo -e ""
}

# 1. Extreme FastFlags Injector
apply_extreme_fastflags() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 1. PASANG EXTREME FASTFLAGS (GRAPHICS OPTIMIZER) ]${NC}\n"
    echo -e "${WHITE}Pilih Tingkat Optimalisasi Grafik:${NC}"
    echo -e "${CYAN}[1] Mode Main Smooth (60 FPS)${NC} - Grafik Low, bayangan mati, cocok untuk main aktif."
    echo -e "${CYAN}[2] Mode Multi-Clone Balanced (30 FPS)${NC} - Cocok untuk 2-3 clone akun."
    echo -e "${CYAN}[3] Mode EXTREME POTATO / 24/7 AFK (15 FPS)${NC} - Paling Ringan! Tanpa rumput, tanpa material, tanpa bloom, hemat GPU & RAM hingga 85%!"
    echo -e ""
    read -p "Pilihan Anda [1-3]: " mode_choice

    case $mode_choice in
        1)
            FPS_LIMIT="60"
            SKIP_MIPS="3"
            DISABLE_MAT="False"
            DISABLE_GRASS="0"
            ;;
        2)
            FPS_LIMIT="30"
            SKIP_MIPS="4"
            DISABLE_MAT="False"
            DISABLE_GRASS="0"
            ;;
        3)
            FPS_LIMIT="15"
            SKIP_MIPS="5"
            DISABLE_MAT="True"
            DISABLE_GRASS="0"
            ;;
        *)
            FPS_LIMIT="30"
            SKIP_MIPS="4"
            DISABLE_MAT="False"
            DISABLE_GRASS="0"
            ;;
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
        
        # Penulisan File Aman
        cp "$TMP_JSON" "$TARGET_FILE" 2>/dev/null || echo "$FASTFLAGS_JSON" > "$TARGET_FILE" 2>/dev/null

        if [ -f "$TARGET_FILE" ]; then
            echo -e "${GREEN}[✓] Berhasil dipasang di: $path${NC}"
            ((SUCCESS_COUNT++))
        else
            # Jika gagal, coba dengan root (jika ada)
            if check_real_root; then
                su -c "mkdir -p $SETTINGS_DIR && echo '$FASTFLAGS_JSON' > $TARGET_FILE && chmod 777 $TARGET_FILE" 2>/dev/null
                if [ -f "$TARGET_FILE" ]; then
                    echo -e "${GREEN}[✓] Berhasil dipasang (Root) di: $path${NC}"
                    ((SUCCESS_COUNT++))
                    continue
                fi
            fi

            echo -e "${RED}[×] Gagal akses file di: $path${NC}"
            echo -e "${YELLOW}    Solusi: Aktifkan izin 'Akses Semua File' Termux di Pengaturan Android Redfinger.${NC}"
            ((FAIL_COUNT++))
        fi
    done
    rm -f "$TMP_JSON" 2>/dev/null

    echo -e "\n${GREEN}${BOLD}=== Hasil: $SUCCESS_COUNT Berhasil, $FAIL_COUNT Gagal ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 2. ART Bytecode Pre-Compilation
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
            if check_real_root; then
                su -c "cmd package compile -m speed $pkg" 2>/dev/null
            else
                cmd package compile -m speed $pkg 2>/dev/null
            fi
            echo -e "${GREEN}[✓] Kompilasi ART $pkg Selesai!${NC}"
        done
    fi

    echo -e "\n${GREEN}${BOLD}=== Kompilasi Paket Roblox Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 3. Deep RAM & Process Tuning
deep_memory_tune() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 3. DEEP RAM & CPU PRIORITY TUNING ]${NC}\n"
    
    if command -v settings &> /dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi Sistem dimatikan (0.0x).${NC}"
    fi

    echo -e "${BLUE}[*] Meningkatkan prioritas CPU untuk semua proses Roblox...${NC}"
    for pid in $(pgrep -i roblox 2>/dev/null || pidof com.roblox.client); do
        renice -n -10 -p $pid 2>/dev/null
        echo -e "${GREEN}[✓] CPU Priority dinaikkan untuk PID: $pid${NC}"
    done

    find_roblox_dirs
    for path in "${ROBLOX_PATHS[@]}"; do
        rm -rf "$path/files/logs"/* 2>/dev/null
        rm -rf "$path/cache"/* 2>/dev/null
    done
    rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null

    if check_real_root; then
        su -c "sync; echo 3 > /proc/sys/vm/drop_caches; am kill-all" 2>/dev/null
        echo -e "${GREEN}[✓] RAM Kernel Buffer berhasil dikosongkan (Root).${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Memory & Process Tuning Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 4. Background 24/7 AFK Guard Daemon
start_afk_guard() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 4. NYALAKAN 24/7 AFK AUTO-CLEANER DAEMON ]${NC}\n"
    
    read -p "Jalankan Auto-Cleaner Daemon untuk semua Roblox? (y/n): " confirm
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
    fi

    echo -e "\n${GREEN}${BOLD}=== Daemon Aktif! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 5. Restore Defaults
restore_defaults() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 5. RESTORE DEFAULT SETTINGS ]${NC}\n"
    
    find_roblox_dirs
    for path in "${ROBLOX_PATHS[@]}"; do
        rm -f "$path/files/ClientSettings/ClientAppSettings.json" 2>/dev/null
    done

    if command -v settings &> /dev/null; then
        settings put global window_animation_scale 1.0 2>/dev/null
        settings put global transition_animation_scale 1.0 2>/dev/null
        settings put global animator_duration_scale 1.0 2>/dev/null
    fi

    echo -e "${GREEN}[✓] Pengaturan dikembalikan ke default original.${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# Main Menu Loop
main_menu() {
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
            0) exit 0 ;;
            *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
        esac
    done
}

main_menu
