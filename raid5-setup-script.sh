#!/bin/bash
# creation du RAID5 avec 5 disques
#preparation des disques
for disk in sdb sdc sdd sde sdf; do
    echo "Effacement de /dev/$disk..."
    mdadm --zero-superblock /dev/$disk 2>/dev/null
    wipefs -a /dev/$disk
    # Créer une partition sur chaque disque
    echo "Création de partition sur /dev/$disk..."
    parted /dev/$disk --script mklabel gpt
    parted /dev/$disk --script mkpart primary 0% 100%
done

# creation du Raid ( pour l'instant 5 disk )
mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# on surveille la creation du Raid
watch -n 5 cat /proc/mdstat

# formatage en ext4
mkfs.ext4 /dev/md0

#montage de la grappe RAID
mkdir -p /mnt/raid5
mount /dev/md0 /mnt/raid5

# sauvegarde de la conf ( pour eviter que md0 deviennet md127 au prochain reboot )
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
update-initramfs -u

