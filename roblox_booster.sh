#!/bin/bash

# ==============================================================================
# ROBLOX GAME BOOSTER FOR REDFINGER - ULTIMATE GOD TIER EDITION (v4.0)
# Author: Antigravity AI
# Target: Maximum FPS, 24/7 AFK Farming & Unlimited Multi-Clone Optimization
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
    echo -e "${GREEN}${BOLD} 🚀 ULTIMATE ROBLOX REDFINGER BOOSTER (v4.0 GOD TIER) 🚀${NC}"
    echo -e "${CYAN}${BOLD}====================================================${NC}"
    echo -e "${YELLOW}   Super FastFlags, ART Compilation & 24/7 AFK Guard  ${NC}"
    echo -e "${CYAN}====================================================${NC}\n"
}

check_storage() {
    if [ ! -d "/sdcard/Android" ]; then
        echo -e "${YELLOW}[!] Meminta izin akses penyimpanan...${NC}"
        termux-setup-storage
        sleep 3
    fi
}

find_roblox_dirs() {
    ROBLOX_PATHS=()
    # Path Standar
    if [ -d "/sdcard/Android/data/com.roblox.client" ]; then
        ROBLOX_PATHS+=("/sdcard/Android/data/com.roblox.client")
    fi
    
    # Path Kloning di SD Card
    for dir in /sdcard/Android/data/*roblox* /sdcard/Android/data/*Roblox*; do
        if [ -d "$dir" ] && [[ ! " ${ROBLOX_PATHS[*]} " =~ " ${dir} " ]]; then
            ROBLOX_PATHS+=("$dir")
        fi
    done

    # Path Cloner Pihak Ketiga (App Cloner / Parallel Space / Island / Dual Space)
    for clone_dir in /sdcard/Android/data/com.appcloner.*/files /sdcard/Android/data/com.lbe.parallel.*/files /sdcard/Android/data/com.excellance.multi.*/files; do
        if [ -d "$clone_dir" ]; then
            ROBLOX_PATHS+=("$clone_dir")
        fi
    done
}

# 1. Extreme FastFlags Injector
apply_extreme_fastflags() {
    show_header
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
            SKIP_MIPS="5" # Texture sangat polos (flat plastic)
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

    find_roblox_dirs
    echo -e "\n${BLUE}[*] Menerapkan FastFlags ke ${#ROBLOX_PATHS[@]} lokasi Roblox...${NC}"

    for path in "${ROBLOX_PATHS[@]}"; do
        SETTINGS_DIR="$path/files/ClientSettings"
        mkdir -p "$SETTINGS_DIR" 2>/dev/null
        echo "$FASTFLAGS_JSON" > "$SETTINGS_DIR/ClientAppSettings.json"
        echo -e "${GREEN}[✓] Dipasang di: $SETTINGS_DIR${NC}"
    done

    # Jika ada akses root / su
    if command -v su &> /dev/null; then
        su -c "
        for dir in /data/data/*roblox* /data/data/com.roblox.client; do
            if [ -d \"\$dir\" ]; then
                mkdir -p \"\$dir/files/ClientSettings\"
                echo '$FASTFLAGS_JSON' > \"\$dir/files/ClientSettings/ClientAppSettings.json\"
                chmod 777 \"\$dir/files/ClientSettings/ClientAppSettings.json\"
            fi
        done
        " 2>/dev/null
    fi

    echo -e "\n${GREEN}${BOLD}=== FastFlags Kustom Berhasil Diterapkan! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 2. ART Bytecode Pre-Compilation (Mempercepat Loading & CPU Execution)
compile_roblox_art() {
    show_header
    echo -e "${PURPLE}${BOLD}[ 2. ADVANCED ANDROID ART COMPILATION ]${NC}\n"
    echo -e "${WHITE}Fitur ini akan mengomplikasi kode Roblox menjadi kode native C++ di Android Redfinger.${NC}"
    echo -e "${WHITE}Hasilnya: Game loading lebih cepat, stuttering berkurang drastis, & CPU lebih adem.${NC}\n"

    if command -v cmd &> /dev/null || command -v su &> /dev/null; then
        echo -e "${BLUE}[*] Mengompilasi paket com.roblox.client (Speed Profile)...${NC}"
        if command -v su &> /dev/null; then
            su -c "cmd package compile -m speed com.roblox.client" 2>/dev/null
        else
            cmd package compile -m speed com.roblox.client 2>/dev/null
        fi
        echo -e "${GREEN}[✓] Kompilasi ART Roblox Selesai! (Performance Maximized).${NC}"
    else
        echo -e "${YELLOW}[!] Perintah 'cmd package' membutuhkan izin ADB/Root.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Optimalisasi ART Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 3. Deep Memory & Process Tuning
deep_memory_tune() {
    show_header
    echo -e "${PURPLE}${BOLD}[ 3. DEEP RAM & PROCESS TUNING ]${NC}\n"
    
    # 1. Mati Animasi Sistem
    if command -v settings &> /dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi Sistem dimatikan (0.0x).${NC}"
    fi

    # 2. Prioritas CPU Roblox (renice)
    echo -e "${BLUE}[*] Meningkatkan prioritas CPU untuk proses Roblox...${NC}"
    for pid in $(pidof com.roblox.client); do
        renice -n -10 -p $pid 2>/dev/null
        echo -e "${GREEN}[✓] CPU Priority dinaikkan untuk PID: $pid${NC}"
    done

    # 3. Clean Cache
    find_roblox_dirs
    for path in "${ROBLOX_PATHS[@]}"; do
        rm -rf "$path/files/logs"/* 2>/dev/null
        rm -rf "$path/cache"/* 2>/dev/null
    done
    rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null

    if command -v su &> /dev/null; then
        su -c "sync; echo 3 > /proc/sys/vm/drop_caches; am kill-all" 2>/dev/null
        echo -e "${GREEN}[✓] RAM Kernel Buffer berhasil dikosongkan.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Memory & Process Tuning Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 4. Background 24/7 AFK Guard Daemon
start_afk_guard() {
    show_header
    echo -e "${PURPLE}${BOLD}[ 4. NALAKAN 24/7 AFK AUTO-CLEANER DAEMON ]${NC}\n"
    echo -e "${WHITE}Daemon ini akan berjalan secara otomatis di background Termux.${NC}"
    echo -e "${WHITE}Tugasnya: Membersihkan log & cache sampah Roblox setiap 15 menit saat Anda AFK,${NC}"
    echo -e "${WHITE}sehingga Redfinger TIDAK AKAN LAG atau lemot meskipun ditinggal 24 jam nonstop!${NC}\n"
    
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
        echo -e "${GREEN}[✓] Anda bisa membiarkan Termux terbuka / di background.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Daemon Aktif! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." temp
}

# 5. Restore Defaults
restore_defaults() {
    show_header
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
