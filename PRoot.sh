#!/bin/sh

############################################################
#                                                          #
#                 ANYACTOR EXPLOIT RUNTIME                 #
#                   Ubuntu 22.04 LTS Core                  #
#                                                          #
############################################################

set -e 

############################
# DIRECTORIES & PARAMETERS
############################

ROOTFS_DIR="$(pwd)/ubuntu-fs"
LOCAL_BIN="$(pwd)/.bin"
MAX_RETRIES=5
TIMEOUT=10

# Force the script to see our locally downloaded binaries
export PATH="$LOCAL_BIN:$PATH:$HOME/.local/usr/bin"
export PROOT_NO_SECCOMP=1 

############################
# TERMINAL CHROMATIC SCALE
############################

RESET='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'

############################
# HARDWARE TARGETING
############################

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH_ALT="amd64" ;;
    aarch64|arm64) ARCH_ALT="arm64" ;;
    *)
        echo -e "${RED}[CRITICAL_ERR] Architecture mismatch: $ARCH${RESET}"
        exit 1
        ;;
esac

############################
# EXPLOIT TERMINAL BANNER
############################

show_logo() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
 █████╗ ███╗   ██╗██╗   ██╗ █████╗  ██████╗████████╗ ██████╗ ██████╗ 
██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗
███████║██╔██╗ ██║ ╚████╔╝ ███████║██║        ██║   ██║   ██║██████╔╝
██╔══██║██║╚██╗██║  ╚██╔╝  ██╔══██║██║        ██║   ██║   ██║██╔══██╗
██║  ██║██║ ╚████║   ██║   ██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
EOF
    echo -e "${RESET}"
    echo -e "${GREEN}=================================================================${RESET}"
    echo -e "${CYAN}             STAGED OVERRIDE RUNTIME: UBUNTU CORE${RESET}"
    echo -e "${WHITE}                     ENGINE: ANYACTOR WORKSPACE${RESET}"
    echo -e "${GREEN}=================================================================${RESET}"
    echo ""
}

############################
# SYSTEM AUTHENTICATION
############################

security_check() {
    echo -e "${CYAN}[SYSTEM] Integrity check pending. Manual override authorization required.${RESET}"
    echo -ne "${YELLOW}[SYSTEM] Input authorization token '${WHITE}execute${YELLOW}' to establish shell: ${RESET}"
    read -r CONFIRM
    
    if [ "$CONFIRM" != "execute" ]; then
        echo -e "${RED}[SYSTEM_DENIED] Authentication token mismatch. Terminating pipeline.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}[SYSTEM] Access granted. Payload sequencing authorized.${RESET}"
    sleep 1
}

############################
# PRE-FLIGHT VERIFICATION
############################

verify_environment() {
    echo -e "${CYAN}[*] Verifying injection binaries (wget, proot, tar)...${RESET}"
    mkdir -p "$LOCAL_BIN"

    # If wget or tar are completely missing on the host, we can't do anything
    if ! command -v wget >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
        echo -e "${RED}[CRITICAL] Base host layer missing required toolsets (wget/tar).${RESET}"
        exit 1
    fi

    # FIX FOR REPLIT: If proot doesn't exist, pull a static unprivileged binary dynamically
    if ! command -v proot >/dev/null 2>&1 && [ ! -f "$LOCAL_BIN/proot" ]; then
        echo -e "${YELLOW}[*] 'proot' not found on host. Downloading local runtime engine...${RESET}"
        
        # Pulls a reliable, statically compiled PRoot binary from standard gitlab builds
        wget --no-hsts -O "$LOCAL_BIN/proot" "https://proot.gitlab.io/proot/bin/proot" || {
            # Fallback mirror if main site has issues
            wget --no-hsts -O "$LOCAL_BIN/proot" "https://raw.githubusercontent.com/proot-me/proot/master/src/proot"
        }
        chmod +x "$LOCAL_BIN/proot"
        echo -e "${GREEN}[+] Local runtime engine loaded successfully.${RESET}"
    fi
}

############################
# MIRROR DATA EXTRACTION
############################

fetch_payload() {
    UBUNTU_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-${ARCH_ALT}.tar.gz"
    
    mkdir -p "$ROOTFS_DIR"
    echo -e "${CYAN}[*] Fetching compressed container core streams...${RESET}"
    
    wget --tries="$MAX_RETRIES" --timeout="$TIMEOUT" --show-progress --no-hsts -O /tmp/rootfs.tar.gz "$UBUNTU_URL"
    
    echo -e "${GREEN}[*] Unpacking filesystem nodes into allocated sector...${RESET}"
    tar -xpf /tmp/rootfs.tar.gz -C "$ROOTFS_DIR" --exclude='dev' --exclude='sys' --exclude='proc'
    
    rm -f /tmp/rootfs.tar.gz
}

############################
# CYBERNETIC MATRIX SEQUENCE
############################

run_hacker_sequence() {
    clear
    echo -e "${GREEN}[+] Memory allocations stabilized. Triggering shell cascade...${RESET}"
    sleep 0.8
    
    for i in $(seq 1 60); do
        case $((i % 5)) in
            0) COLOR=$GREEN ;;
            1) COLOR=$CYAN ;;
            2) COLOR=$RED ;;
            3) COLOR=$MAGENTA ;;
            *) COLOR=$YELLOW ;;
        esac
        
        HEX_CHUNK_1=$(cat /dev/urandom | tr -dc 'A-F0-9' | head -c 16 2>/dev/null || echo "7F494E4A01010100")
        HEX_CHUNK_2=$(cat /dev/urandom | tr -dc 'A-F0-9' | head -c 16 2>/dev/null || echo "0000000000000000")
        BIN_CHUNK=$(cat /dev/urandom | tr -dc '01' | head -c 24 2>/dev/null || echo "110100101110")
        
        echo -e "${COLOR}STACK_PTR_0x${i}A7B8F9 :: [${HEX_CHUNK_1}:${HEX_CHUNK_2}] :: REG_OVRD_HI_${BIN_CHUNK}${RESET}"
        usleep 25000 2>/dev/null || sleep 0.02
    done
    
    echo ""
    echo -e "${RED}» INJECTING MEMORY SHADOW MASKS... [SUCCESS]${RESET}"
    sleep 0.3
    echo -e "${MAGENTA}» RE-ROUTING HOST NETWORKING PIPES... [SUCCESS]${RESET}"
    sleep 0.3
    echo -e "${CYAN}» VIRTUAL DISK ARRAY MATRIX DEPLOYED... [SUCCESS]${RESET}"
    sleep 0.4
    echo -e "${GREEN}» ANYACTOR PROTOCOL ENVIROMENT: ONLINE${RESET}"
    sleep 1.2
    clear
}

############################
# INFRASTRUCTURE NETWORKING
############################

configure_network_layer() {
    echo "nameserver 1.1.1.1" > "$ROOTFS_DIR/etc/resolv.conf"
    echo "nameserver 8.8.8.8" >> "$ROOTFS_DIR/etc/resolv.conf"
    
    cat > "$ROOTFS_DIR/root/.first_run.sh" << 'EOF'
#!/bin/bash
clear
echo -e "\033[1;31m=====================================================\033[0m"
echo -e "\033[1;32m      ANYACTOR EXPLOIT TERMINAL FRAMEWORK ONLINE     \033[0m"
echo -e "\033[1;31m=====================================================\033[0m"
echo -e "\033[1;36m SYSTEM BOUNDARIES BYPASSED. USER ROOT PRIVILEGES UNLOCKED.\033[0m"
echo ""
exec /bin/bash --login
EOF
    chmod +x "$ROOTFS_DIR/root/.first_run.sh"

    touch "$ROOTFS_DIR/.installed"
}

############################
# VECTOR LOGISTICS
############################

show_terminal_metrics() {
    RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}' 2>/dev/null || echo "DYNAMIC")
    CPU_CORES=$(nproc 2>/dev/null || echo "ALL")
    
    echo -e "${GREEN}[+] Target Container Diagnostics:${RESET}"
    echo -e " ⚡ Node Anchor   : ${WHITE}Anyactor Host Engine${RESET}"
    echo -e " ⚡ Compute Matrix : ${WHITE}$CPU_CORES Operational Cores${RESET}"
    echo -e " ⚡ Image Blueprint: ${WHITE}Ubuntu Core Platform${RESET}"
    echo -e " ⚡ Memory Ceiling : ${WHITE}${RAM_TOTAL} MB Allocated${RESET}"
    echo ""
    echo -e "${MAGENTA}[*] Initializing isolated shell gateway...${RESET}"
    sleep 1.2
}

############################
# CONTROL EXECUTION
############################

show_logo
security_check
verify_environment

if [ ! -f "$ROOTFS_DIR/.installed" ]; then
    echo -e "${YELLOW}[*] Staging fresh filesystem sandbox environment...${RESET}"
    fetch_payload
    run_hacker_sequence
    configure_network_layer
fi

show_terminal_metrics

############################
# ENGINE COUPLING (PRoot)
############################

# Dynamically targets whichever proot binary is available (system or local fallback)
PROOT_BIN=$(command -v proot || echo "$LOCAL_BIN/proot")

exec "$PROOT_BIN" \
    --rootfs="$ROOTFS_DIR" \
    -0 \
    -w /root \
    -b /dev \
    -b /sys \
    -b /proc \
    -b /tmp \
    -b /etc/resolv.conf \
    --kill-on-exit \
    /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    /bin/bash /root/.first_run.sh
