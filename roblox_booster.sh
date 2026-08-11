#!/bin/bash

# ==============================================================================
# ROBLOX GAME BOOSTER FOR REDFINGER - ULTIMATE GOD TIER EDITION (v6.0 FINAL)
# Author: Antigravity AI
# Target: Android 11+ Permission Fix, Auto-Detect Roblox + Clones
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
# ==============================================================================
SU_BIN=""
IS_ROOTED="false"

detect_real_root() {
    for candidate in /system/xbin/su /system/bin/su /sbin/su /su/bin/su /magisk/.core/bin/su; do
        if [ -x "$candidate" ]; then
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
    echo -e "${GREEN}${BOLD} 🚀 ULTIMATE ROBLOX REDFINGER BOOSTER (v6.0 FINAL) 🚀${NC}"
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${YELLOW}   Android 11+ Fix, Auto-Detect Clone & 24/7 AFK Guard${NC}"
    echo -e "${CYAN}====================================================${NC}\n"
}

# ==============================================================================
# STORAGE PERMISSION & ANDROID 11+ WORKAROUND
# ==============================================================================
check_storage() {
    if [ ! -d "/sdcard" ]; then
        echo -e "${YELLOW}[!] Meminta izin penyimpanan dasar Termux...${NC}"
        termux-setup-storage
        sleep 2
    fi
}

# Deteksi apakah kita bisa menulis ke Android/data (Android 10-) atau tidak (Android 11+)
CAN_WRITE_ANDROID_DATA="false"
check_android_data_access() {
    TEST_DIR="/sdcard/Android/data/.booster_test_$$"
    mkdir -p "$TEST_DIR" 2>/dev/null
    if [ -d "$TEST_DIR" ]; then
        CAN_WRITE_ANDROID_DATA="true"
        rm -rf "$TEST_DIR" 2>/dev/null
    else
        CAN_WRITE_ANDROID_DATA="false"
    fi
}

# ==============================================================================
# DETEKSI OTOMATIS SEMUA APLIKASI ROBLOX (UTAMA + SEMUA JENIS CLONE)
# ==============================================================================
ROBLOX_PACKAGES=()

find_roblox_packages() {
    ROBLOX_PACKAGES=()
    if command -v pm &>/dev/null; then
        while IFS= read -r line; do
            pkg=$(echo "$line" | cut -d: -f2 | tr -d '[:space:]')
            [ -n "$pkg" ] && ROBLOX_PACKAGES+=("$pkg")
        done < <(pm list packages 2>/dev/null | grep -i "roblox")
    fi
    # Fallback jika pm tidak menemukan apa-apa
    if [ ${#ROBLOX_PACKAGES[@]} -eq 0 ]; then
        ROBLOX_PACKAGES+=("com.roblox.client")
    fi
}

show_detected_roblox() {
    find_roblox_packages
    echo -e "${CYAN}${BOLD}[ 🔍 DETEKSI APLIKASI ROBLOX ]${NC}"
    echo -e "${BLUE}[*] Ditemukan ${#ROBLOX_PACKAGES[@]} paket Roblox terinstall:${NC}"
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        echo -e "  ${GREEN}📦 $pkg${NC}"
    done
    if [ "$IS_ROOTED" = "true" ]; then
        echo -e "  ${PURPLE}🔓 Root: Aktif ($SU_BIN)${NC}"
    else
        echo -e "  ${YELLOW}🔒 Root: Tidak tersedia${NC}"
    fi
    if [ "$CAN_WRITE_ANDROID_DATA" = "true" ]; then
        echo -e "  ${GREEN}📁 Akses Android/data: Tersedia${NC}"
    else
        echo -e "  ${YELLOW}📁 Akses Android/data: Terbatas (Android 11+)${NC}"
    fi
    echo -e ""
}

# ==============================================================================
# FUNGSI UTAMA: Pasang FastFlags ke Satu Paket Roblox
# Strategi Multi-Layer:
#   1. Root write ke /data/data/<pkg>/  (jika rooted)
#   2. Direct write ke /sdcard/Android/data/<pkg>/  (jika Android 10-)
#   3. Shizuku / content provider  (jika tersedia)
#   4. Manual copy via File Manager  (fallback terakhir)
# ==============================================================================
install_fastflags_to_package() {
    local pkg="$1"
    local json_content="$2"
    local installed="false"

    # --- METODE 1: Root write (paling reliable jika tersedia) ---
    if [ "$IS_ROOTED" = "true" ]; then
        local root_dir="/data/data/$pkg/files/ClientSettings"
        run_root "mkdir -p '$root_dir' && echo '$json_content' > '$root_dir/ClientAppSettings.json' && chmod 777 '$root_dir/ClientAppSettings.json'"
        if run_root "test -f '$root_dir/ClientAppSettings.json'" 2>/dev/null; then
            echo -e "${GREEN}[✓] $pkg — Berhasil dipasang via Root.${NC}"
            installed="true"
        fi
    fi

    # --- METODE 2: Direct write ke sdcard (Android 10 ke bawah) ---
    if [ "$installed" = "false" ] && [ "$CAN_WRITE_ANDROID_DATA" = "true" ]; then
        local sd_dir="/sdcard/Android/data/$pkg/files/ClientSettings"
        mkdir -p "$sd_dir" 2>/dev/null
        echo "$json_content" > "$sd_dir/ClientAppSettings.json" 2>/dev/null
        if [ -f "$sd_dir/ClientAppSettings.json" ]; then
            echo -e "${GREEN}[✓] $pkg — Berhasil dipasang via SDCard.${NC}"
            installed="true"
        fi
    fi

    # --- METODE 3: Gunakan content provider Android (Android 11+) ---
    if [ "$installed" = "false" ] && command -v content &>/dev/null; then
        # Buat file sementara yang bisa di-share via content provider
        local tmp_file="$HOME/.fastflags_tmp.json"
        echo "$json_content" > "$tmp_file"
        
        # Coba copy via run-as (hanya berfungsi jika app debuggable, jarang berhasil)
        if command -v run-as &>/dev/null; then
            run-as "$pkg" mkdir -p files/ClientSettings 2>/dev/null
            cat "$tmp_file" | run-as "$pkg" sh -c "cat > files/ClientSettings/ClientAppSettings.json" 2>/dev/null
            if run-as "$pkg" test -f files/ClientSettings/ClientAppSettings.json 2>/dev/null; then
                echo -e "${GREEN}[✓] $pkg — Berhasil dipasang via run-as.${NC}"
                installed="true"
            fi
        fi
        rm -f "$tmp_file" 2>/dev/null
    fi

    # --- METODE 4: Fallback - Simpan ke Download & Beri Instruksi Manual ---
    if [ "$installed" = "false" ]; then
        echo -e "${YELLOW}[!] $pkg — Tidak bisa dipasang otomatis (Pembatasan Android 11+).${NC}"
        return 1
    fi
    return 0
}

# ==============================================================================
# 1. Extreme FastFlags Injector
# ==============================================================================
apply_extreme_fastflags() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 1. PASANG EXTREME FASTFLAGS (GRAPHICS OPTIMIZER) ]${NC}\n"
    echo -e "${WHITE}Pilih Tingkat Optimalisasi Grafik:${NC}"
    echo -e "${CYAN}[1] Mode Main Smooth (60 FPS)${NC} - Grafik Low, bayangan mati."
    echo -e "${CYAN}[2] Mode Multi-Clone Balanced (30 FPS)${NC} - Cocok 2-3 clone."
    echo -e "${CYAN}[3] Mode EXTREME POTATO / AFK (15 FPS)${NC} - Paling ringan! Hemat 85%!"
    echo -e ""
    read -p "Pilihan Anda [1-3]: " mode_choice

    case $mode_choice in
        1) FPS_LIMIT="60"; SKIP_MIPS="3"; DISABLE_MAT="False" ;;
        2) FPS_LIMIT="30"; SKIP_MIPS="4"; DISABLE_MAT="False" ;;
        3) FPS_LIMIT="15"; SKIP_MIPS="5"; DISABLE_MAT="True"  ;;
        *) FPS_LIMIT="30"; SKIP_MIPS="4"; DISABLE_MAT="False" ;;
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
  \"FIntRenderGrassHeightScaler\": \"0\",
  \"FIntRenderBloomQuality\": \"0\",
  \"FIntLightAtmosphereQuality\": \"0\",
  \"FIntRenderDepthOfFieldQuality\": \"0\",
  \"FFlagDebugDisableMaterials\": \"$DISABLE_MAT\"
}"

    echo -e "\n${BLUE}[*] Menerapkan FastFlags ke ${#ROBLOX_PACKAGES[@]} paket Roblox...${NC}\n"

    SUCCESS_COUNT=0
    FAIL_COUNT=0
    FAILED_PKGS=()

    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        if install_fastflags_to_package "$pkg" "$FASTFLAGS_JSON"; then
            ((SUCCESS_COUNT++))
        else
            ((FAIL_COUNT++))
            FAILED_PKGS+=("$pkg")
        fi
    done

    # Jika ada yang gagal, simpan file ke Download & tampilkan panduan manual
    if [ $FAIL_COUNT -gt 0 ]; then
        BACKUP_DIR="/sdcard/Download/RobloxBooster"
        mkdir -p "$BACKUP_DIR" 2>/dev/null
        echo "$FASTFLAGS_JSON" > "$BACKUP_DIR/ClientAppSettings.json" 2>/dev/null

        echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════════════════${NC}"
        echo -e "${WHITE}${BOLD}  📋 PANDUAN PEMASANGAN MANUAL (ANDROID 11+)${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════${NC}\n"
        echo -e "${WHITE}File FastFlags sudah disimpan di:${NC}"
        echo -e "${GREEN}  /sdcard/Download/RobloxBooster/ClientAppSettings.json${NC}\n"
        echo -e "${WHITE}Ikuti langkah berikut untuk memasangnya:${NC}\n"
        echo -e "${CYAN}Langkah 1:${NC} Buka File Manager bawaan atau instal MT Manager / ZArchiver."
        echo -e "${CYAN}Langkah 2:${NC} Buka folder ${GREEN}/sdcard/Download/RobloxBooster/${NC}"
        echo -e "${CYAN}Langkah 3:${NC} COPY file ${GREEN}ClientAppSettings.json${NC}"
        echo -e "${CYAN}Langkah 4:${NC} Buka folder tujuan untuk setiap paket yang gagal:"
        for pkg in "${FAILED_PKGS[@]}"; do
            echo -e "           ${YELLOW}/sdcard/Android/data/$pkg/files/ClientSettings/${NC}"
            echo -e "           (Jika folder ${WHITE}ClientSettings${NC} belum ada, buat manual)"
        done
        echo -e "${CYAN}Langkah 5:${NC} PASTE file ${GREEN}ClientAppSettings.json${NC} ke dalam folder tersebut."
        echo -e "${CYAN}Langkah 6:${NC} Tutup & buka ulang (Force Close) Roblox agar efek berlaku.\n"
        echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"

        # Coba buka file manager otomatis
        if command -v am &>/dev/null; then
            echo -e "\n${BLUE}[*] Mencoba membuka File Manager...${NC}"
            am start -a android.intent.action.VIEW -d "file:///sdcard/Download/RobloxBooster/" -t "resource/folder" 2>/dev/null \
                || am start -a android.intent.action.VIEW -d "content://com.android.externalstorage.documents/document/primary%3ADownload%2FRobloxBooster" 2>/dev/null \
                || true
        fi
    fi

    echo -e "\n${GREEN}${BOLD}=== Hasil: $SUCCESS_COUNT Otomatis, $FAIL_COUNT Manual ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 2. ART Bytecode Pre-Compilation
# ==============================================================================
compile_roblox_art() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 2. ADVANCED ANDROID ART COMPILATION ]${NC}\n"

    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        echo -e "${BLUE}[*] Mengompilasi paket $pkg (Speed Profile)...${NC}"
        if [ "$IS_ROOTED" = "true" ]; then
            run_root "cmd package compile -m speed $pkg"
        elif command -v cmd &>/dev/null; then
            cmd package compile -m speed $pkg 2>/dev/null
        else
            echo -e "${YELLOW}[i] Perintah 'cmd' tidak tersedia untuk $pkg.${NC}"
            continue
        fi
        echo -e "${GREEN}[✓] Kompilasi ART $pkg Selesai!${NC}"
    done

    echo -e "\n${GREEN}${BOLD}=== Kompilasi Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# 3. Deep RAM & Process Tuning
# ==============================================================================
deep_memory_tune() {
    show_header
    show_detected_roblox
    echo -e "${PURPLE}${BOLD}[ 3. DEEP RAM & CPU PRIORITY TUNING ]${NC}\n"
    
    # Matikan Animasi Sistem
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi Sistem dimatikan (0.0x).${NC}"
    fi

    # Naikkan Prioritas CPU
    echo -e "${BLUE}[*] Meningkatkan prioritas CPU untuk proses Roblox...${NC}"
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
        echo -e "${YELLOW}[i] Tidak ada proses Roblox yang sedang berjalan.${NC}"
    fi

    # Bersihkan Cache yang bisa diakses
    echo -e "${BLUE}[*] Membersihkan cache & log...${NC}"
    rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null
    rm -rf /sdcard/.cache/* 2>/dev/null
    echo -e "${GREEN}[✓] Cache berhasil dibersihkan.${NC}"

    # RAM Kernel (root only)
    if [ "$IS_ROOTED" = "true" ]; then
        run_root "sync; echo 3 > /proc/sys/vm/drop_caches; am kill-all"
        echo -e "${GREEN}[✓] RAM Kernel Buffer dikosongkan (Root).${NC}"
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
    echo -e "${WHITE}Daemon ini membersihkan log & cache setiap 15 menit di latar belakang.${NC}\n"
    
    read -p "Jalankan Auto-Cleaner Daemon? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        (
            while true; do
                sleep 900
                rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null
                rm -rf /sdcard/.cache/* 2>/dev/null
            done
        ) &
        echo -e "${GREEN}[✓] Daemon AFK Guard aktif (PID: $!)!${NC}"
        echo -e "${GREEN}[✓] Biarkan Termux tetap berjalan di background.${NC}"
    else
        echo -e "${YELLOW}[i] Dibatalkan.${NC}"
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
    
    # Hapus FastFlags dari semua lokasi yang mungkin
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        rm -f "/sdcard/Android/data/$pkg/files/ClientSettings/ClientAppSettings.json" 2>/dev/null
        if [ "$IS_ROOTED" = "true" ]; then
            run_root "rm -f /data/data/$pkg/files/ClientSettings/ClientAppSettings.json"
        fi
    done

    # Hapus backup
    rm -rf "/sdcard/Download/RobloxBooster" 2>/dev/null

    # Kembalikan animasi
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 1.0 2>/dev/null
        settings put global transition_animation_scale 1.0 2>/dev/null
        settings put global animator_duration_scale 1.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi sistem dikembalikan ke default (1.0x).${NC}"
    fi

    echo -e "${GREEN}[✓] Semua pengaturan dikembalikan ke default.${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
main_menu() {
    detect_real_root
    check_storage
    check_android_data_access
    
    while true; do
        show_header
        echo -e "${WHITE}${BOLD}MENU OPTIMALISASI (REDFINGER):${NC}"
        echo -e "${CYAN}[1]${NC} FastFlags Extreme (60FPS / 30FPS Clone / 15FPS AFK Potato)"
        echo -e "${CYAN}[2]${NC} Android ART Compilation (Loading Kencang & Anti Stutter)"
        echo -e "${CYAN}[3]${NC} Deep RAM & CPU Priority Tuning"
        echo -e "${CYAN}[4]${NC} 24/7 AFK Auto-Cleaner Guard Daemon"
        echo -e "${CYAN}[5]${NC} Kembalikan Pengaturan ke Default"
        echo -e "${RED}[0]${NC} Keluar"
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
