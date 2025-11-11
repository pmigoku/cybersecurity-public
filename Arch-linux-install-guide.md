# Arch Linux on ThinkPad X1: Encrypted Btrfs/KDE Guide

This guide details a complete Arch Linux installation on a ThinkPad X1 using LVM on LUKS encryption and a **Btrfs** filesystem with subvolumes.

**Configuration Goals:**

- **Desktop:** KDE Plasma with Wayland
- **Encryption:** LUKS on LVM
- **Filesystem:** **Btrfs** with subvolumes for `/` (`@`) and `/home` (`@home`)
- **LVM Name:** The Btrfs volume will be named `btrfs_pool`
- **Swap:** `zram-generator` (no swap partition)
- **Network:** Legacy interface names (`wlan0`)
- **Security:** AppArmor & UFW Firewall
- **Features:** Btrfs compression and snapshot support

------

### Phase 1: Boot and Prepare (Live USB)

1. **Boot & Verify UEFI:**

   - Boot from your Arch USB.

   - Ensure you're in UEFI mode (this command should list files):

     Bash

     ```
     ls /sys/firmware/efi/efivars
     ```

2. **Connect to Wi-Fi:**

   - Start the `iwctl` tool:

     Bash

     ```
     iwctl
     ```

   - Inside `iwctl`:

     ```
     device list
     station wlan0 scan
     station wlan0 get-networks
     station wlan0 connect "Your-SSID-Name"
     exit
     ```

   - Test your connection:

     Bash

     ```
     ping archlinux.org
     ```

3. **Update Clock:**

   Bash

   ```
   timedatectl set-ntp true
   ```

------



### Phase 2: Partition and Encrypt



1. **Identify Drive:**

   - Run `lsblk`. Your drive is likely `/dev/nvme0n1`.

2. **Partition with `gdisk`:**

   - Start `gdisk` on your drive:

     Bash

     ```
     gdisk /dev/nvme0n1
     ```

   - At the `gdisk` prompt, enter these commands in order:

     - `o` (Create a new empty GPT partition table)
     - `n` (New partition 1, for EFI)
       - `Partition number`: **Enter**
       - `First sector`: **Enter**
       - `Last sector`: `+512M`
       - `Hex code`: `ef00`
     - `n` (New partition 2, for encrypted system)
       - `Partition number`: **Enter**
       - `First sector`: **Enter**
       - `Last sector`: **Enter** (use remaining space)
       - `Hex code`: `8309` (Linux LVM)
     - `w` (Write changes and exit)

3. **Set Up Encryption (LUKS):**

   - This erases partition 2. Use a strong passphrase.

   Bash

   ```
   cryptsetup luksFormat /dev/nvme0n1p2
   ```

   - Type `YES` (all caps) to confirm.

4. **Open Encrypted Volume:**

   - We'll unlock it and name it `cryptlvm`.

   Bash

   ```
   cryptsetup open /dev/nvme0n1p2 cryptlvm
   ```

------



### Phase 3: LVM Setup (Modified)



1. **Initialize LVM:**

   Bash

   ```
   pvcreate /dev/mapper/cryptlvm
   vgcreate vg0 /dev/mapper/cryptlvm
   ```

2. **Create Single Volume for Btrfs:**

   - We will create a single logical volume named `btrfs_pool`.

   Bash

   ```
   lvcreate -l 100%FREE vg0 -n btrfs_pool
   ```

------



### Phase 4: Format and Mount (Btrfs - Modified)



1. **Format Btrfs:**

   - Format the `btrfs_pool` LVM volume we just created.

   Bash

   ```
   mkfs.btrfs /dev/vg0/btrfs_pool
   ```

2. **Mount Top-Level Btrfs Volume (Temporary):**

   Bash

   ```
   mount /dev/vg0/btrfs_pool /mnt
   ```

3. **Create Btrfs Subvolumes:**

   - We create subvolumes for `root` (`@`) and `home` (`@home`).

   Bash

   ```
   btrfs subvolume create /mnt/@
   btrfs subvolume create /mnt/@home
   ```

4. **Unmount and Re-mount Subvolumes (Properly):**

   - Now we mount the subvolumes with performance options (`compress`, `ssd`, `noatime`).

   Bash

   ```
   umount /mnt
   
   # Mount root subvolume
   mount -o compress=zstd,ssd,noatime,subvol=@ /dev/vg0/btrfs_pool /mnt
   
   # Create mountpoint for home and mount home subvolume
   mkdir -p /mnt/home
   mount -o compress=zstd,ssd,noatime,subvol=@home /dev/vg0/btrfs_pool /mnt/home
   ```

5. **Format and Mount EFI Partition:**

   Bash

   ```
   mkfs.fat -F32 /dev/nvme0n1p1
   mkdir -p /mnt/boot/efi
   mount /dev/nvme0n1p1 /mnt/boot/efi
   ```

------



### Phase 5: Install System & KDE



1. **Install All Packages:**

   - We've added `btrfs-progs` to the list.

   Bash

   ```
   pacstrap -K /mnt base linux linux-firmware lvm2 btrfs-progs vim networkmanager intel-ucode apparmor sudo sddm plasma-meta konsole pipewire pipewire-pulse pipewire-alsa
   ```

2. **Generate `fstab`:**

   - `genfstab` will intelligently detect our Btrfs subvolumes and options.

   Bash

   ```
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

------



### Phase 6: Configure System (chroot)



1. **Enter Your New System:**

   Bash

   ```
   arch-chroot /mnt
   ```

2. **Timezone & Locale:**

   Bash

   ```
   ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
   hwclock --systohc
   ```

   - Edit `/etc/locale.gen` (e.g., `vim /etc/locale.gen`) and uncomment your locale (e.g., `en_US.UTF-8 UTF-8`).

   - Run `locale-gen`.

   - Create `/etc/locale.conf`:

     Bash

     ```
     echo "LANG=en_US.UTF-8" > /etc/locale.conf
     ```

3. **Network & Hostname:**

   - Set your computer's name:

     Bash

     ```
     echo "my-x1" > /etc/hostname
     ```

   - Edit `/etc/hosts` and add:

     ```
     127.0.0.1   localhost
     ::1         localhost
     127.0.1.1   my-x1.localdomain   my-x1
     ```

4. **Passwords:**

   - Set the `root` user's password:

     Bash

     ```
     passwd
     ```

   - Create your personal user (replace `yourusername`):

     Bash

     ```
     useradd -m -G wheel -s /bin/bash yourusername
     ```

   - Set your personal user's password:

     Bash

     ```
     passwd yourusername
     ```

5. **Grant Sudo Access:**

   - Run `EDITOR=vim visudo` and uncomment this line:

     ```
     %wheel ALL=(ALL:ALL) ALL
     ```

------



### Phase 7: Configure Initramfs & Bootloader (Modified)



1. **Configure `mkinitcpio` (For Encryption):**

   - Edit `/etc/mkinitcpio.conf`.
   - Find the `HOOKS=(...)` line.
   - **Modify it** to include `keyboard`, `encrypt`, and `lvm2` **before** `filesystems`:

   > `HOOKS=(base udev autodetect modconf keyboard keymap consolefont block encrypt lvm2 filesystems fsck)`

2. **Rebuild `initramfs`:**

   - Apply your changes.

   Bash

   ```
   mkinitcpio -P
   ```

3. **Install Bootloader (systemd-boot):**

   Bash

   ```
   bootctl --path=/boot/efi install
   ```

4. **Create Loader Config:**

   - Create `/boot/efi/loader/loader.conf`:

     Bash

     ```
     vim /boot/efi/loader/loader.conf
     ```

   - Add this content:

     ```
     default arch.conf
     timeout 3
     ```

5. **Get Encryption UUID:**

   - Run this command and **copy the UUID** of your `nvme0n1p2` partition.

   Bash

   ```
   blkid /dev/nvme0n1p2
   ```

6. **Create Boot Entry (Very Important!):**

   - Create `/boot/efi/loader/entries/arch.conf`:

     Bash

     ```
     vim /boot/efi/loader/entries/arch.conf
     ```

   - Paste this, replacing `<YOUR-UUID-HERE>` with the UUID you copied.

   - **Note the `root=` parameter now points to `/dev/vg0/btrfs_pool`.**

     ```
     title   Arch Linux
     linux   /vmlinuz-linux
     initrd  /intel-ucode.img
     initrd  /initramfs-linux.img
     options cryptdevice=UUID=<YOUR-UUID-HERE>:cryptlvm root=/dev/vg0/btrfs_pool rw rootflags=subvol=@ net.ifnames=0 apparmor=1 security=apparmor
     ```

   - **This `options` line tells the kernel to:**

     - `cryptdevice=...`: Unlock your encrypted drive.
     - `root=/dev/vg0/btrfs_pool`: Use your LVM volume as the root *device*.
     - `rootflags=subvol=@`: Tell the kernel to mount the `@` subvolume as the *actual* root filesystem.
     - `net.ifnames=0`: Use old network names (`wlan0`).
     - `apparmor=1 security=apparmor`: Enable AppArmor.

------



### Phase 8: Enable Services and Reboot



1. **Enable Core Services:**

   - We want the network, graphical login, and AppArmor to start on boot.

   Bash

   ```
   systemctl enable NetworkManager
   systemctl enable sddm.service
   systemctl enable apparmor.service
   ```

2. **Exit and Reboot:**

   Bash

   ```
   exit
   umount -R /mnt
   cryptsetup close cryptlvm
   reboot
   ```

   *Remove your USB drive.*

------



### Phase 9: Post-Install (Fully Usable & Secure)



After you reboot, log in as `yourusername`.

1. **Connect to Wi-Fi:**

   - Use the network icon in the system tray to connect to your Wi-Fi.

2. **Set Up `zram` (Swap):**

   - Open a terminal (like `konsole`).

   Bash

   ```
   sudo pacman -S zram-generator
   ```

   - Create the config file:

   Bash

   ```
   sudo vim /etc/systemd/zram-generator.conf
   ```

   - Add this content:

     ```
     [zram0]
     zram-size = ram / 2
     compression-algorithm = zstd
     swap-priority = 100
     ```

3. **Configure Firewall (`ufw`):**

   Bash

   ```
   sudo pacman -S ufw
   sudo ufw default deny incoming
   sudo ufw default allow outgoing
   sudo ufw allow ssh  # Good practice
   sudo ufw enable
   sudo systemctl enable ufw.service
   ```

   - (Type `y` to proceed when enabling).

4. **Install AUR Helper (`yay`):**

   Bash

   ```
   sudo pacman -S --needed git base-devel
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   cd ..
   rm -rf yay
   ```

5. **Configure AppArmor (Required):**

   - Install the community-provided profiles:

   Bash

   ```
   yay -S apparmor-profiles
   ```

   - You can check the status with `sudo aa-status`.

6. **Configure Btrfs Snapshots (Snapper):**

   - This is the main benefit of Btrfs.

   Bash

   ```
   # Install snapper
   sudo pacman -S snapper
   
   # Install tools to automate snapshots
   yay -S snap-pac btrfs-assistant
   ```

   - **Create Snapper Configs:**

     - (Snapper will create a new `/.snapshots` subvolume for you).

     Bash

     ```
     sudo snapper -c root create-config /
     ```

   - **Enable Automatic Snapshot Timers:**

     Bash

     ```
     sudo systemctl enable snapper-timeline.timer
     sudo systemctl enable snapper-cleanup.timer
     ```

   - `snap-pac` will now automatically take snapshots before/after any `pacman` transaction.

   - `btrfs-assistant` is a great GUI app (you'll find it in your start menu) to manage your Btrfs subvolumes and snapshots.

7. **Install Fonts & Media Codecs:**

   Bash

   ```
   sudo pacman -S noto-fonts noto-fonts-emoji noto-fonts-cjk gstreamer gst-plugins-good gst-plugins-bad gst-plugins-ugly
   ```

8. **Enable Bluetooth:**

   Bash

   ```
   sudo pacman -S bluez bluez-utils
   sudo systemctl enable bluetooth.service
   ```

9. **Final Reboot:**

   - Reboot one last time to ensure all services (zram, bluetooth, snapper timers) are running.

   Bash

   ```
   reboot
   ```

Your Btrfs system is now fully configured, encrypted, and secure.
