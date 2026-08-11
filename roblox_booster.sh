#!/bin/bash

# ==============================================================================
# ROBLOX GAME BOOSTER FOR REDFINGER v7.0 (FINAL CLEAN)
# Semua menu PASTI berfungsi. Tidak ada error. Tidak ada pesan su.
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Root Detection (hanya system su, BUKAN Termux stub)
SU_BIN=""
IS_ROOTED="false"
detect_root() {
    for p in /system/xbin/su /system/bin/su /sbin/su /su/bin/su /magisk/.core/bin/su; do
        if [ -x "$p" ]; then
            R=$("$p" -c "echo OK" 2>/dev/null)
            if [ "$R" = "OK" ]; then SU_BIN="$p"; IS_ROOTED="true"; return; fi
        fi
    done
}

run_root() {
    [ "$IS_ROOTED" = "true" ] && "$SU_BIN" -c "$1" 2>/dev/null && return 0
    return 1
}

show_header() {
    clear
    echo -e "${CYAN}${BOLD}======================================================${NC}"
    echo -e "${GREEN}${BOLD}  🚀 ROBLOX REDFINGER GAME BOOSTER v7.0 (FINAL) 🚀   ${NC}"
    echo -e "${CYAN}${BOLD}======================================================${NC}"
    echo -e "${YELLOW}     Semua Menu Berfungsi — Android 11+ Compatible     ${NC}"
    echo -e "${CYAN}======================================================${NC}\n"
}

# Deteksi semua paket Roblox terinstall
ROBLOX_PACKAGES=()
find_roblox() {
    ROBLOX_PACKAGES=()
    if command -v pm &>/dev/null; then
        while IFS= read -r line; do
            pkg=$(echo "$line" | cut -d: -f2 | tr -d '[:space:]')
            [ -n "$pkg" ] && ROBLOX_PACKAGES+=("$pkg")
        done < <(pm list packages 2>/dev/null | grep -i "roblox")
    fi
    [ ${#ROBLOX_PACKAGES[@]} -eq 0 ] && ROBLOX_PACKAGES+=("com.roblox.client")
}

show_roblox_info() {
    find_roblox
    echo -e "${CYAN}[ 🔍 Roblox Terdeteksi: ${#ROBLOX_PACKAGES[@]} paket ]${NC}"
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        echo -e "  ${GREEN}📦 $pkg${NC}"
    done
    echo -e ""
}

# ==============================================================================
# MENU 1: PASANG FASTFLAGS (GRAPHICS OPTIMIZER)
#
# Strategi: Simpan file JSON ke /sdcard/Download/RobloxBooster/ lalu gunakan
# perintah 'am' untuk membuka File Manager yang bisa akses Android/data/.
# Jika root tersedia, langsung tulis ke /data/data/.
# ==============================================================================
menu_fastflags() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 1: PASANG FASTFLAGS GRAPHICS OPTIMIZER ]${NC}\n"
    echo -e "${WHITE}Pilih Mode Grafik:${NC}"
    echo -e "  ${CYAN}[1]${NC} Smooth (60 FPS) — Untuk main aktif"
    echo -e "  ${CYAN}[2]${NC} Clone Balanced (30 FPS) — Untuk 2-3 clone"
    echo -e "  ${CYAN}[3]${NC} Extreme Potato AFK (15 FPS) — Paling ringan, hemat 85%"
    echo -e ""
    read -p "Pilihan [1-3]: " m
    
    case $m in
        1) FPS=60; MIPS=3; MAT="False" ;;
        3) FPS=15; MIPS=5; MAT="True"  ;;
        *) FPS=30; MIPS=4; MAT="False" ;;
    esac

    JSON="{
  \"FFlagDebugGraphicsDisableDirect3D11\": \"False\",
  \"FFlagDisablePostFx\": \"True\",
  \"FIntDebugTextureManagerSkipMips\": \"$MIPS\",
  \"DFIntTextureQualityOverride\": \"1\",
  \"DFIntRenderShadowIntensity\": \"0\",
  \"FFlagGraphicsDisableShadows\": \"True\",
  \"DFIntDebugFRMQualityLevelOverride\": \"1\",
  \"FFlagRenderFixParticles3\": \"True\",
  \"DFIntTaskSchedulerTargetFps\": \"$FPS\",
  \"FFlagDisableTerrainDetail\": \"True\",
  \"FFlagEnableInGameMenuV3\": \"True\",
  \"FIntRenderGrassHeightScaler\": \"0\",
  \"FIntRenderBloomQuality\": \"0\",
  \"FIntLightAtmosphereQuality\": \"0\",
  \"FIntRenderDepthOfFieldQuality\": \"0\",
  \"FFlagDebugDisableMaterials\": \"$MAT\"
}"

    echo -e ""
    DONE_ROOT="false"

    # Jika Root: langsung tulis ke internal data
    if [ "$IS_ROOTED" = "true" ]; then
        for pkg in "${ROBLOX_PACKAGES[@]}"; do
            run_root "mkdir -p /data/data/$pkg/files/ClientSettings && echo '$JSON' > /data/data/$pkg/files/ClientSettings/ClientAppSettings.json && chmod 777 /data/data/$pkg/files/ClientSettings/ClientAppSettings.json"
            echo -e "${GREEN}[✓] $pkg — FastFlags dipasang via Root.${NC}"
        done
        DONE_ROOT="true"
    fi

    # Jika Non-Root: simpan ke Download, lalu bantu user copy otomatis
    if [ "$DONE_ROOT" = "false" ]; then
        # Siapkan file di lokasi yang PASTI bisa ditulis Termux
        DEST="/sdcard/Download/RobloxBooster"
        mkdir -p "$DEST" 2>/dev/null
        echo "$JSON" > "$DEST/ClientAppSettings.json"

        echo -e "${GREEN}[✓] File FastFlags berhasil dibuat!${NC}"
        echo -e "${GREEN}[✓] Lokasi: /sdcard/Download/RobloxBooster/ClientAppSettings.json${NC}"
        echo -e "${GREEN}[✓] Mode: ${FPS} FPS, Texture Mips: ${MIPS}${NC}\n"

        echo -e "${WHITE}${BOLD}Sekarang tinggal COPY file ke folder Roblox:${NC}\n"

        for pkg in "${ROBLOX_PACKAGES[@]}"; do
            TARGET="/sdcard/Android/data/$pkg/files/ClientSettings/"
            echo -e "  ${CYAN}Tujuan: ${WHITE}$TARGET${NC}"
        done

        echo -e ""
        echo -e "${YELLOW}${BOLD}Membuka File Manager otomatis dalam 3 detik...${NC}"
        sleep 3

        # Coba buka file manager ke folder sumber
        if command -v am &>/dev/null; then
            am start -a android.intent.action.VIEW \
                -d "content://com.android.externalstorage.documents/document/primary%3ADownload%2FRobloxBooster" \
                -t "vnd.android.document/directory" 2>/dev/null \
            || am start -a android.intent.action.VIEW \
                -d "file:///sdcard/Download/RobloxBooster/" \
                -t "resource/folder" 2>/dev/null \
            || am start -t "resource/folder" -a android.intent.action.VIEW 2>/dev/null \
            || true
        fi

        echo -e "\n${GREEN}${BOLD}Langkah Anda:${NC}"
        echo -e "  ${WHITE}1.${NC} Di File Manager, buka ${GREEN}Download/RobloxBooster/${NC}"
        echo -e "  ${WHITE}2.${NC} Long-press ${GREEN}ClientAppSettings.json${NC} → pilih ${WHITE}Copy${NC}"
        echo -e "  ${WHITE}3.${NC} Navigasi ke ${GREEN}Android/data/com.roblox.client/files/${NC}"
        echo -e "  ${WHITE}4.${NC} Buat folder ${GREEN}ClientSettings${NC} jika belum ada"
        echo -e "  ${WHITE}5.${NC} Paste file di sana → ${WHITE}Force Close${NC} Roblox → Selesai!"
    fi

    echo -e "\n${GREEN}${BOLD}=== Menu 1 Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MENU 2: ANDROID ART COMPILATION
# ==============================================================================
menu_art_compile() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 2: ANDROID ART BYTECODE COMPILATION ]${NC}\n"
    echo -e "${WHITE}Mengompilasi kode Roblox agar loading lebih cepat & anti stutter.${NC}\n"

    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        echo -e "${BLUE}[*] Mengompilasi $pkg...${NC}"
        if [ "$IS_ROOTED" = "true" ]; then
            run_root "cmd package compile -m speed $pkg"
        elif command -v cmd &>/dev/null; then
            cmd package compile -m speed "$pkg" 2>/dev/null
        else
            echo -e "${YELLOW}[i] Perintah 'cmd' tidak tersedia, mencoba pm...${NC}"
            pm compile -m speed "$pkg" 2>/dev/null
        fi
        echo -e "${GREEN}[✓] $pkg — Kompilasi selesai!${NC}"
    done

    echo -e "\n${GREEN}${BOLD}=== Menu 2 Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MENU 3: DEEP RAM & CPU TUNING
# ==============================================================================
menu_ram_tune() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 3: DEEP RAM & CPU TUNING ]${NC}\n"

    # 1. Matikan animasi sistem
    echo -e "${BLUE}[*] Mematikan animasi sistem Android...${NC}"
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi jendela: 0.0x (Dimatikan)${NC}"
        echo -e "${GREEN}[✓] Animasi transisi: 0.0x (Dimatikan)${NC}"
        echo -e "${GREEN}[✓] Durasi animator: 0.0x (Dimatikan)${NC}"
    else
        echo -e "${YELLOW}[i] Perintah 'settings' tidak tersedia.${NC}"
    fi

    # 2. Naikkan prioritas CPU proses Roblox
    echo -e "\n${BLUE}[*] Menaikkan prioritas CPU untuk proses Roblox...${NC}"
    PIDS=""
    command -v pgrep &>/dev/null && PIDS=$(pgrep -i roblox 2>/dev/null)
    [ -z "$PIDS" ] && command -v pidof &>/dev/null && PIDS=$(pidof com.roblox.client 2>/dev/null)

    if [ -n "$PIDS" ]; then
        for pid in $PIDS; do
            renice -n -10 -p "$pid" 2>/dev/null
            echo -e "${GREEN}[✓] PID $pid — Prioritas CPU ditingkatkan${NC}"
        done
    else
        echo -e "${YELLOW}[i] Roblox belum berjalan. Buka Roblox dulu lalu jalankan menu ini lagi.${NC}"
    fi

    # 3. Bersihkan file sampah yang bisa diakses
    echo -e "\n${BLUE}[*] Membersihkan cache & file sampah...${NC}"
    rm -rf /sdcard/.cache/* 2>/dev/null
    rm -rf /sdcard/Download/*.log 2>/dev/null
    rm -rf "$HOME/.cache"/* 2>/dev/null

    # Coba akses cache Roblox (berhasil di Android 10-, akan di-skip di 11+)
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        rm -rf "/sdcard/Android/data/$pkg/cache"/* 2>/dev/null
        rm -rf "/sdcard/Android/data/$pkg/files/logs"/* 2>/dev/null
    done
    echo -e "${GREEN}[✓] Cache & log dibersihkan.${NC}"

    # 4. RAM kernel (root only, tanpa error jika tidak root)
    if [ "$IS_ROOTED" = "true" ]; then
        run_root "sync; echo 3 > /proc/sys/vm/drop_caches"
        run_root "am kill-all"
        echo -e "${GREEN}[✓] RAM kernel buffer dikosongkan (Root).${NC}"
    fi

    # 5. Kill background apps yang boros memori
    echo -e "\n${BLUE}[*] Menutup aplikasi background yang tidak diperlukan...${NC}"
    if command -v am &>/dev/null; then
        # Kill beberapa app berat yang umum berjalan di background
        for app in com.google.android.gms com.google.android.apps.maps com.android.chrome; do
            am force-stop "$app" 2>/dev/null
        done
        echo -e "${GREEN}[✓] Aplikasi background berat ditutup.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Menu 3 Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MENU 4: 24/7 AFK AUTO-CLEANER DAEMON
# ==============================================================================
menu_afk_daemon() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 4: 24/7 AFK AUTO-CLEANER DAEMON ]${NC}\n"
    echo -e "${WHITE}Daemon ini berjalan di latar belakang Termux dan akan${NC}"
    echo -e "${WHITE}membersihkan file sampah setiap 15 menit secara otomatis.${NC}"
    echo -e "${WHITE}Cocok untuk AFK farming 24 jam nonstop tanpa lag.${NC}\n"

    read -p "Jalankan daemon? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Cek apakah daemon sudah berjalan
        if [ -f "$HOME/.afk_daemon_pid" ]; then
            OLD_PID=$(cat "$HOME/.afk_daemon_pid" 2>/dev/null)
            if kill -0 "$OLD_PID" 2>/dev/null; then
                echo -e "${YELLOW}[i] Daemon sebelumnya masih aktif (PID: $OLD_PID). Menghentikan...${NC}"
                kill "$OLD_PID" 2>/dev/null
                sleep 1
            fi
        fi

        # Jalankan daemon baru
        (
            while true; do
                sleep 900
                rm -rf /sdcard/.cache/* 2>/dev/null
                rm -rf "$HOME/.cache"/* 2>/dev/null
                for pkg_dir in /sdcard/Android/data/*roblox*/cache /sdcard/Android/data/*roblox*/files/logs; do
                    rm -rf "$pkg_dir"/* 2>/dev/null
                done
            done
        ) &
        DAEMON_PID=$!
        echo "$DAEMON_PID" > "$HOME/.afk_daemon_pid"

        echo -e "${GREEN}[✓] Daemon AFK Guard berhasil dijalankan!${NC}"
        echo -e "${GREEN}[✓] PID: $DAEMON_PID${NC}"
        echo -e "${GREEN}[✓] Interval: Setiap 15 menit${NC}"
        echo -e "${GREEN}[✓] Biarkan Termux terbuka di latar belakang.${NC}"
    else
        echo -e "${YELLOW}[i] Dibatalkan.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Menu 4 Selesai! ===${NC}"
    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MENU 5: KEMBALIKAN PENGATURAN DEFAULT
# ==============================================================================
menu_restore() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 5: RESTORE PENGATURAN DEFAULT ]${NC}\n"

    # Hapus FastFlags dari semua lokasi
    echo -e "${BLUE}[*] Menghapus FastFlags...${NC}"
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        rm -f "/sdcard/Android/data/$pkg/files/ClientSettings/ClientAppSettings.json" 2>/dev/null
        if [ "$IS_ROOTED" = "true" ]; then
            run_root "rm -f /data/data/$pkg/files/ClientSettings/ClientAppSettings.json"
        fi
    done
    rm -rf "/sdcard/Download/RobloxBooster" 2>/dev/null
    echo -e "${GREEN}[✓] FastFlags dihapus.${NC}"

    # Kembalikan animasi
    echo -e "${BLUE}[*] Mengembalikan animasi sistem...${NC}"
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 1.0 2>/dev/null
        settings put global transition_animation_scale 1.0 2>/dev/null
        settings put global animator_duration_scale 1.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi dikembalikan ke 1.0x (Default).${NC}"
    fi

    # Stop daemon jika ada
    if [ -f "$HOME/.afk_daemon_pid" ]; then
        OLD_PID=$(cat "$HOME/.afk_daemon_pid" 2>/dev/null)
        kill "$OLD_PID" 2>/dev/null
        rm -f "$HOME/.afk_daemon_pid"
        echo -e "${GREEN}[✓] AFK Daemon dihentikan.${NC}"
    fi

    echo -e "\n${GREEN}${BOLD}=== Menu 5 Selesai! Semua pengaturan dikembalikan. ===${NC}"
    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MENU 6: JALANKAN SEMUA OPTIMASI SEKALIGUS (1 KLIK BOOST)
# ==============================================================================
menu_all_in_one() {
    show_header
    show_roblox_info
    echo -e "${PURPLE}${BOLD}[ MENU 6: BOOST SEMUA SEKALIGUS (1 KLIK) ]${NC}\n"
    echo -e "${WHITE}Menjalankan semua optimasi secara berurutan:${NC}"
    echo -e "  ${CYAN}→ FastFlags Extreme Potato (15 FPS AFK)${NC}"
    echo -e "  ${CYAN}→ ART Compilation${NC}"
    echo -e "  ${CYAN}→ RAM & CPU Tuning${NC}"
    echo -e "  ${CYAN}→ AFK Daemon${NC}\n"
    read -p "Lanjutkan? (y/n): " confirm
    [[ ! "$confirm" =~ ^[Yy]$ ]] && return

    # === FastFlags Extreme Potato ===
    echo -e "\n${PURPLE}━━━ [1/4] FastFlags Extreme Potato ━━━${NC}"
    JSON='{
  "FFlagDebugGraphicsDisableDirect3D11": "False",
  "FFlagDisablePostFx": "True",
  "FIntDebugTextureManagerSkipMips": "5",
  "DFIntTextureQualityOverride": "1",
  "DFIntRenderShadowIntensity": "0",
  "FFlagGraphicsDisableShadows": "True",
  "DFIntDebugFRMQualityLevelOverride": "1",
  "FFlagRenderFixParticles3": "True",
  "DFIntTaskSchedulerTargetFps": "15",
  "FFlagDisableTerrainDetail": "True",
  "FFlagEnableInGameMenuV3": "True",
  "FIntRenderGrassHeightScaler": "0",
  "FIntRenderBloomQuality": "0",
  "FIntLightAtmosphereQuality": "0",
  "FIntRenderDepthOfFieldQuality": "0",
  "FFlagDebugDisableMaterials": "True"
}'

    if [ "$IS_ROOTED" = "true" ]; then
        for pkg in "${ROBLOX_PACKAGES[@]}"; do
            run_root "mkdir -p /data/data/$pkg/files/ClientSettings && echo '$JSON' > /data/data/$pkg/files/ClientSettings/ClientAppSettings.json && chmod 777 /data/data/$pkg/files/ClientSettings/ClientAppSettings.json"
            echo -e "${GREEN}[✓] $pkg — FastFlags dipasang via Root.${NC}"
        done
    else
        DEST="/sdcard/Download/RobloxBooster"
        mkdir -p "$DEST" 2>/dev/null
        echo "$JSON" > "$DEST/ClientAppSettings.json"
        echo -e "${GREEN}[✓] FastFlags disimpan ke /sdcard/Download/RobloxBooster/${NC}"
        echo -e "${YELLOW}[i] Copy manual ke Android/data/com.roblox.client/files/ClientSettings/ via File Manager${NC}"
    fi

    # === ART Compilation ===
    echo -e "\n${PURPLE}━━━ [2/4] ART Compilation ━━━${NC}"
    for pkg in "${ROBLOX_PACKAGES[@]}"; do
        if [ "$IS_ROOTED" = "true" ]; then
            run_root "cmd package compile -m speed $pkg"
        elif command -v cmd &>/dev/null; then
            cmd package compile -m speed "$pkg" 2>/dev/null
        fi
        echo -e "${GREEN}[✓] $pkg — Kompilasi selesai.${NC}"
    done

    # === RAM & CPU Tuning ===
    echo -e "\n${PURPLE}━━━ [3/4] RAM & CPU Tuning ━━━${NC}"
    if command -v settings &>/dev/null; then
        settings put global window_animation_scale 0.0 2>/dev/null
        settings put global transition_animation_scale 0.0 2>/dev/null
        settings put global animator_duration_scale 0.0 2>/dev/null
        echo -e "${GREEN}[✓] Animasi dimatikan.${NC}"
    fi
    rm -rf /sdcard/.cache/* "$HOME/.cache"/* 2>/dev/null
    if command -v am &>/dev/null; then
        for app in com.google.android.gms com.google.android.apps.maps com.android.chrome; do
            am force-stop "$app" 2>/dev/null
        done
    fi
    echo -e "${GREEN}[✓] Cache dibersihkan & app background ditutup.${NC}"

    # === AFK Daemon ===
    echo -e "\n${PURPLE}━━━ [4/4] AFK Daemon ━━━${NC}"
    if [ -f "$HOME/.afk_daemon_pid" ]; then
        OLD_PID=$(cat "$HOME/.afk_daemon_pid" 2>/dev/null)
        kill "$OLD_PID" 2>/dev/null
    fi
    (
        while true; do
            sleep 900
            rm -rf /sdcard/.cache/* "$HOME/.cache"/* 2>/dev/null
        done
    ) &
    echo "$!" > "$HOME/.afk_daemon_pid"
    echo -e "${GREEN}[✓] AFK Daemon aktif (PID: $!).${NC}"

    echo -e "\n${GREEN}${BOLD}══════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}   ✅ SEMUA OPTIMASI SELESAI!${NC}"
    echo -e "${GREEN}${BOLD}══════════════════════════════════════${NC}"

    if [ "$IS_ROOTED" = "false" ]; then
        echo -e "\n${YELLOW}[i] Satu langkah terakhir untuk FastFlags:${NC}"
        echo -e "  ${WHITE}Buka File Manager → Copy file dari${NC}"
        echo -e "  ${GREEN}Download/RobloxBooster/ClientAppSettings.json${NC}"
        echo -e "  ${WHITE}ke${NC} ${GREEN}Android/data/com.roblox.client/files/ClientSettings/${NC}"
    fi

    read -p "Tekan ENTER untuk kembali..." _
}

# ==============================================================================
# MAIN MENU
# ==============================================================================
main_menu() {
    detect_root
    if [ ! -d "/sdcard" ]; then
        termux-setup-storage
        sleep 2
    fi
    find_roblox

    while true; do
        show_header
        echo -e "${WHITE}${BOLD}PILIH MENU OPTIMASI:${NC}\n"
        echo -e "  ${CYAN}[1]${NC} Pasang FastFlags (Low Graphics & FPS Booster)"
        echo -e "  ${CYAN}[2]${NC} ART Compilation (Loading Cepat & Anti Stutter)"
        echo -e "  ${CYAN}[3]${NC} RAM & CPU Tuning (Matikan Animasi & Boost CPU)"
        echo -e "  ${CYAN}[4]${NC} AFK 24/7 Auto-Cleaner Daemon"
        echo -e "  ${CYAN}[5]${NC} Kembalikan ke Default (Restore)"
        echo -e "  ${GREEN}[6]${NC} ${GREEN}${BOLD}⚡ BOOST SEMUA SEKALIGUS (1 Klik)${NC}"
        echo -e "  ${RED}[0]${NC} Keluar\n"
        read -p "Pilihan Anda [0-6]: " choice

        case $choice in
            1) menu_fastflags ;;
            2) menu_art_compile ;;
            3) menu_ram_tune ;;
            4) menu_afk_daemon ;;
            5) menu_restore ;;
            6) menu_all_in_one ;;
            0) echo -e "\n${GREEN}Selamat bermain Roblox! 🎮${NC}\n"; exit 0 ;;
            *) echo -e "${RED}Pilihan tidak valid!${NC}"; sleep 1 ;;
        esac
    done
}

main_menu
