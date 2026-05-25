#!/bin/sh

############################################################
#                                                          #
#                 ANYACTOR PROOT SYSTEM                    #
#                   Ubuntu 22.04 LTS VM                    #
#                                                          #
############################################################

set -e # Exit immediately if a command exits with a non-zero status

############################
# DIRECTORIES & SETTINGS
############################

ROOTFS_DIR="$(pwd)/ubuntu-fs"
MAX_RETRIES=5
TIMEOUT=10

export PATH="$PATH:$HOME/.local/usr/bin"
export PROOT_NO_SECCOMP=1 # Stabilizes PRoot on restricted environments

############################
# COLORS
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
# ARCH DETECTION
############################

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH_ALT="amd64" ;;
    aarch64|arm64) ARCH_ALT="arm64" ;;
    *)
        echo -e "${RED}[ERROR] Unsupported architecture: $ARCH${RESET}"
        exit 1
        ;;
esac

############################
# AESTHETIC LOGO
############################

show_logo() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
 █████╗ ███╗   ██╗██╗   ██╗ █████╗  ██████╗████████╗ ██████╗ ██████╗ 
██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗
███████║██╔██╗ ██║ ╚████╔╝ ███████║██║        ██║   ██║   ██║██████╔╝
██╔══██║██║╚██╗██║  ╚██╔╝  ██╔══██║██║        ██║   ██║   ██║██╔══██╗
██║  ██║██║ ╚████║   ██║   ██║  ██║╚██████╗   ██║   ╚██████╔╝██║  ██║
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}                  Ubuntu 22.04 LTS Proot VM${RESET}"
    echo -e "${YELLOW}                     Powered By ANYACTOR${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

############################
# SECURITY VERIFICATION
############################

security_check() {
    echo -e "${RED}[SECURITY CAUTION] You are about to deploy an isolated Linux environment.${RESET}"
    echo -ne "${YELLOW}Type ${WHITE}execute${YELLOW} and press Enter to proceed: ${RESET}"
    read -r CONFIRM
    
    if [ "$CONFIRM" != "execute" ]; then
        echo -e "${RED}[ACCESS DENIED] Verification failed. Aborting.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}[+] Verification successful. Initialization granted.${RESET}"
    sleep 1
}

############################
# CORE DEPENDENCIES
############################

install_dependencies() {
    echo -e "${CYAN}[*] Verifying system dependencies...${RESET}"
    
    if ! command -v wget >/dev/null 2>&1 || ! command -v proot >/dev/null 2>&1 || ! command -v tar >/dev/null 2>&1; then
        echo -e "${YELLOW}[*] Installing missing core packages...${RESET}"
        
        if command -v apt >/dev/null 2>&1; then
            apt update -y && apt install wget curl tar xz-utils proot git -y
        elif command -v apk >/dev/null 2>&1; then
            apk add wget curl tar xz proot git
        elif command -v yum >/dev/null 2>&1; then
            yum install wget curl tar xz proot git -y
        else
            echo -e "${RED}[ERROR] Unsupported package manager. Install proot, wget, and tar manually.${RESET}"
            exit 1
        fi
    fi
}

############################
# FILE SYSTEM DEPLOYMENT
############################

install_ubuntu() {
    UBUNTU_URL="https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-${ARCH_ALT}.tar.gz"
    
    mkdir -p "$ROOTFS_DIR"
    echo -e "${CYAN}[*] Downloading Ubuntu 22.04 RootFS...${RESET}"
    
    wget --tries="$MAX_RETRIES" --timeout="$TIMEOUT" --show-progress --no-hsts -O /tmp/rootfs.tar.gz "$UBUNTU_URL"
    
    echo -e "${GREEN}[*] Extracting filesystem layers...${RESET}"
    tar -xpf /tmp/rootfs.tar.gz -C "$ROOTFS_DIR" --exclude='dev' --exclude='sys' --exclude='proc'
    
    rm -f /tmp/rootfs.tar.gz
}

############################
# HACKER MATRIX SEQUENCE
############################

run_hacker_sequence() {
    clear
    echo -e "${GREEN}[*] Injection complete. Initializing payload override...${RESET}"
    sleep 1
    
    # Fast scrolling matrix text lines
    for i in $(seq 1 40); do
        # Randomly choose color between Green, Cyan, Red, Magenta
        case $((i % 4)) in
            0) COLOR=$GREEN ;;
            1) COLOR=$CYAN ;;
            2) COLOR=$RED ;;
            *) COLOR=$MAGENTA ;;
        esac
        
        # Generate random terminal characters strings
        HEX_STRING=$(cat /dev/urandom | tr -dc 'A-F0-9[:space:]' | head -c 60 || echo "00 F1 A3 DE 99 88 BC C2")
        echo -e "${COLOR}0x${i}F7C: ${HEX_STRING}${RESET}"
        usleep 30000 2>/dev/null || sleep 0.03
    done
    
    echo ""
    echo -e "${RED}» OVERRIDING KERNEL HOOKS... [OK]${RESET}"
    sleep 0.4
    echo -e "${CYAN}» MOUNTING VIRTUAL FILESYSTEM MATRIX... [OK]${RESET}"
    sleep 0.4
    echo -e "${GREEN}» ESTABLISHING ANYACTOR PROTOCOL ENVIROMENT... [SUCCESS]${RESET}"
    sleep 1
    clear
}

############################
# CONFIGURE ENVIRONMENT
############################

configure_system() {
    echo -e "${CYAN}[*] Adjusting networking and internal scripts...${RESET}"
    
    echo "nameserver 1.1.1.1" > "$ROOTFS_DIR/etc/resolv.conf"
    echo "nameserver 8.8.8.8" >> "$ROOTFS_DIR/etc/resolv.conf"
    
    # Internal Setup Script
    cat > "$ROOTFS_DIR/root/setup.sh" << 'EOF'
#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y sudo curl wget nano vim git htop neofetch net-tools openssh-server ca-certificates software-properties-common zip unzip screen tmux python3 python3-pip
echo "root:root" | chpasswd
mkdir -p /var/run/sshd
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
rm -f /root/setup.sh
EOF

    chmod +x "$ROOTFS_DIR/root/setup.sh"
    
    # Execution wrapper
    cat > "$ROOTFS_DIR/root/.first_run.sh" << 'EOF'
#!/bin/bash
if [ -f /root/setup.sh ]; then
    echo -e "\033[1;35m[*] Running automated setup scripts inside Anyactor container...\033[0m"
    /root/setup.sh
    clear
    echo -e "\033[1;32m======================================\033[0m"
    echo -e "\033[1;36m      ANYACTOR UBUNTU VM READY        \033[0m"
    echo -e "\033[1;32m======================================\033[0m"
    echo ""
    neofetch
fi
exec /bin/bash --login
EOF
    chmod +x "$ROOTFS_DIR/root/.first_run.sh"

    touch "$ROOTFS_DIR/.installed"
}

############################
# SYSTEM METRICS
############################

show_system_info() {
    RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    CPU_CORES=$(nproc)
    DISK_FREE=$(df -h "$ROOTFS_DIR" 2>/dev/null | awk 'NR==2 {print $4}' || echo "N/A")
    
    echo -e "${GREEN}Container Metrics:${RESET}"
    echo -e " ├─ Host Identity : ${WHITE}Anyactor Node${RESET}"
    echo -e " ├─ CPU Alloc     : ${WHITE}$CPU_CORES Core(s)${RESET}"
    echo -e " ├─ Target Engine : ${WHITE}Ubuntu 22.04 LTS${RESET}"
    echo -e " ├─ System RAM    : ${WHITE}${RAM_TOTAL} MB${RESET}"
    echo -e " └─ Storage Alloc : ${WHITE}$DISK_FREE Free${RESET}"
    echo ""
    echo -e "${MAGENTA}[*] Booting container terminal...${RESET}"
    sleep 1.5
}

############################
# MAIN EXECUTION
############################

show_logo
security_check
install_dependencies

if [ ! -f "$ROOTFS_DIR/.installed" ]; then
    echo -e "${YELLOW}[*] New environment environment container footprint detected.${RESET}"
    install_ubuntu
    run_hacker_sequence
    configure_system
fi

show_system_info

############################
# START PRoot ENGINE
############################

exec proot \
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
