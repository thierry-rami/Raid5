#!/bin/bash

# afificher etat du disque 
mdadm --detail /dev/md0

#Simulation de panne du disque /dev/sdc
mdadm /dev/md0 --fail /dev/sdc1

#État du RAID après la panne
mdadm --detail /dev/md0

