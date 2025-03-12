#!/bin/bash
# État initial du RAID
mdadm --detail /dev/md0

# Retirer le disque défectueux du RAID
mdadm /dev/md0 --remove /dev/sdc1

#État du RAID après retrait
mdadm --detail /dev/md0

#Préparation du disque de spare (/dev/sdg) ==="
# S'assurer que le disque de spare est propre
mdadm --zero-superblock /dev/sdg 2>/dev/null
wipefs -a /dev/sdg
# Créer une partition sur le disque de spare
parted /dev/sdg --script mklabel gpt
parted /dev/sdg --script mkpart primary 0% 100%

# Ajouter le nouveau disque au RAID
mdadm /dev/md0 --add /dev/sdg1

# Reconstruction du RAID
watch -n 5 cat /proc/mdstat

# État final du RAID après reconstruction
mdadm --detail /dev/md0

