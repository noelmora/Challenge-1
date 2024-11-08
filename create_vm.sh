#!/bin/bash

if [ "$#" -ne 8 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_os> <cpus> <ram_mb> <vram_mb> <disk_size_mb> <nombre_controlador_sata> <nombre_controlador_ide>"
    exit 1
fi

NOMBRE_VM="$1"
TIPO_OS="$2"
CPUS="$3"
RAM_MB="$4"
VRAM_MB="$5"
DISK_SIZE_MB="$6"
NOMBRE_CONTROLADOR_SATA="$7"
NOMBRE_CONTROLADOR_IDE="$8"

VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_OS" --register
echo "Máquina virtual '$NOMBRE_VM' creada con tipo de OS: $TIPO_OS."

VBoxManage modifyvm "$NOMBRE_VM" --memory "$RAM_MB" --vram "$VRAM_MB"
echo "RAM configurada a ${RAM_MB}MB y VRAM configurada a ${VRAM_MB}MB."

VBoxManage modifyvm "$NOMBRE_VM" --cpus "$CPUS"
echo "Número de CPUs configurado a $CPUS."

VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$NOMBRE_VM/$NOMBRE_VM.vdi" --size "$DISK_SIZE_MB" --format VDI
VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_CONTROLADOR_SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$NOMBRE_CONTROLADOR_SATA" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$NOMBRE_VM/$NOMBRE_VM.vdi"
echo "Disco duro virtual de ${DISK_SIZE_MB}MB creado y asociado al controlador SATA '$NOMBRE_CONTROLADOR_SATA'."

VBoxManage storagectl "$NOMBRE_VM" --name "$NOMBRE_CONTROLADOR_IDE" --add ide --controller PIIX4
echo "Controlador IDE '$NOMBRE_CONTROLADOR_IDE' creado y asociado para CD/DVD."

VBoxManage showvminfo "$NOMBRE_VM"
echo "Configuración de la máquina virtual '$NOMBRE_VM' completada."
