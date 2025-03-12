#!/bin/bash

# État initial du RAID
mdadm --detail /dev/md0

# Préparation du disque pour hot spare (/dev/sdc ancien disk fail )
mdadm --zero-superblock /dev/sdc 2>/dev/null
wipefs -a /dev/sdc

# Créer une partition sur le disque
parted /dev/sdc --script mklabel gpt
parted /dev/sdc --script mkpart primary 0% 100%

# Ajouter le disque comme hot spare
mdadm /dev/md0 --add /dev/sdc1

# État final du RAID avec hot spare
mdadm --detail /dev/md0
