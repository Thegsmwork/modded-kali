#!/data/data/com.termux/files/usr/bin/bash -e

# Color codes for styling
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
C="\033[1;36m"
W="\033[1;37m"

# Display banner
banner() {
    clear
    printf "${Y}       █▄▀    ▄▀█    █░░    █    ▄▀█    █▀█    █▀▄${W}\n"
    printf "${C}       █░█    █▀█    █▄▄    █    █▀█    █▄█    █▄▀${W}\n"
    printf "${G}   Modded Kali NetHunter Setup${W}\n"
    printf "${G}   By @sabamdarif${W}\n\n"
}

# Function to detect device architecture
detect_architecture() {
    printf "${B}[*] Detecting device architecture...${W}\n"
    case "$(uname -m)" in
        aarch64) SYS_ARCH="arm64" ;;
        arm) SYS_ARCH="armhf" ;;
        amd64|x86_64) SYS_ARCH="amd64" ;;
        i*86|x86) SYS_ARCH="i386" ;;
        *)
            printf "${R}Unknown architecture. Exiting.${W}\n"
            exit 1
            ;;
    esac
    printf "${G}[+] Architecture detected: ${SYS_ARCH}${W}\n"
}

# Function to set image type based on user input
set_image_type() {
    echo ""
    if [[ ${SYS_ARCH} == "arm64" ]]; then
        echo "[1] NetHunter ARM64 (full)"
        echo "[2] NetHunter ARM64 (minimal)"
        echo "[3] NetHunter ARM64 (nano)"
        read -p "Enter the image you want to install: " wimg
        case $wimg in
            1) IMG_TYPE="full" ;;
            2) IMG_TYPE="minimal" ;;
            3) IMG_TYPE="nano" ;;
            *) IMG_TYPE="full" ;;
        esac
    elif [[ ${SYS_ARCH} == "armhf" ]]; then
        echo "[1] NetHunter ARMhf (full)"
        echo "[2] NetHunter ARMhf (minimal)"
        echo "[3] NetHunter ARMhf (nano)"
        read -p "Enter the image you want to install: " wimg
        case $wimg in
            1) IMG_TYPE="full" ;;
            2) IMG_TYPE="minimal" ;;
            3) IMG_TYPE="nano" ;;
            *) IMG_TYPE="full" ;;
        esac
    else
        printf "${R}Unsupported architecture. Exiting.${W}\n"
        exit 1
    fi
}

# Function to manage root filesystem setup
setup_rootfs() {
    local BASE_URL="https://kali.download/nethunter-images/current/rootfs"
    local ROOTFS_FILE="kali-nethunter-rootfs-${IMG_TYPE}-${SYS_ARCH}.tar.xz"

    if [ -f "$ROOTFS_FILE" ]; then
        printf "${G}File found:${W} ${Y}$ROOTFS_FILE${W}\n"

        while true; do
            printf "${B}1) Remove the file${W}\n"
            printf "${B}2) Rename the file${W}\n"
            printf "${B}3) Continue with the existing file${W}\n"

            read -p "${G}Enter your choice (1/2/3): ${W}" CHOICE
            case $CHOICE in
                1)
                    rm "$ROOTFS_FILE"
                    printf "${G}[+] File removed.${W}\n"
                    break
                    ;;
                2)
                    read -p "${G}Enter new name for the file: ${W}" NEW_NAME
                    mv "$ROOTFS_FILE" "$NEW_NAME"
                    printf "${G}[+] File renamed to $NEW_NAME.${W}\n"
                    break
                    ;;
                3)
                    printf "${G}[+] Continuing with the existing file.${W}\n"
                    break
                    ;;
                *)
                    printf "${R}Invalid choice. Please try again.${W}\n"
                    ;;
            esac
        done
    else
        printf "${B}[*] Downloading rootfs (${IMG_TYPE} version)...${W}\n"
        wget "$BASE_URL/$ROOTFS_FILE"
    fi
}

# Main execution flow
banner

detect_architecture

set_image_type

setup_rootfs

printf "${G}[=] Modded Kali NetHunter setup complete.${W}\n"
