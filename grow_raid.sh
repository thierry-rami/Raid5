#!/bin/bash
# État initial du RAID
mdadm --detail /dev/md0
df -h /mnt/raid5

# Préparation des nouveaux disques
# Préparation des nouveaux disques
for disk in sdh sdi; do
    echo "Préparation de /dev/$disk..."
    mdadm --zero-superblock /dev/$disk 2>/dev/null
    wipefs -a /dev/$disk
    parted /dev/$disk --script mklabel gpt
    parted /dev/$disk --script mkpart primary 0% 100%
    echo "Disque /dev/$disk prêt"
done

# Ajout des nouveaux disques au RAID
mdadm --add /dev/md0 /dev/sdh1 /dev/sdi1

# Vérification de l'état du RAID avec les nouveaux disques
mdadm --detail /dev/md0

# Extension du RAID à 7 disques actifs (5 originaux + 2 nouveaux)
mdadm --grow /dev/md0 --raid-devices=7

# Surveillance de la progression
watch -n 5 cat /proc/mdstat

# État après extension 
mdadm --detail /dev/md0

# Extension du système de fichiers
e2fsck -f /dev/md0
resize2fs /dev/md0

# Vérification de l'espace disque après extension
df -h /mnt/raid5

# Mise à jour de la configuration
mdadm --detail --scan > /etc/mdadm/mdadm.conf
update-initramfs -u
