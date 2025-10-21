#!/bin/bash

#Configurações de pós-instalação
USERNAME="jocker"

echo "Executando configurações pós-instalação..."

#Configurar Yakuake
su - ${USERNAME} -c "mkdir -p /home/${USERNAME}/.config/yakuake"
cat > /home/${USERNAME}/.config/yakuake/kns_rc << YAKUAKE_EOF
[Desktop Entry]
DefaultProfile=profile1

[General]
RememberWindowSize=false

[profile1]
BackgroundFile=
ColorScheme=Breeze
Font=Monospace,12,-1,5,50,0,0,0,0,0
YAKUAKE_EOF

chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.config/yakuake/kns_rc

#Configurar atalhos de teclado
cat > /home/${USERNAME}/.config/kglobalshortcutsrc << SHORTCUTS_EOF
[yakuake]
toggle=Ctrl+Alt+T,Ctrl+Alt+T,Toggle Yakuake
SHORTCUTS_EOF

#Configurar cliente SMB
cat > /home/${USERNAME}/.smbcredentials << SMB_EOF
username=jockersmb
password=JGr@99154700
SMB_EOF

chmod 600 /home/${USERNAME}/.smbcredentials
chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.smbcredentials


# Exemplo de montagem SMB no fstab
echo "# Exemplo de montagem SMB" >> /etc/fstab
echo "//servidor/share /mnt/smb cifs credentials=/home/${USERNAME}/.smbcredentials,uid=1000,gid=1000 0 0" >> /etc/fstab

#Criar diretorio para montagem smb
mkdir -p /mnt/smb
chown ${USERNAME}:${USERNAME} /mnt/smb

# Configurar SSH (opcional)
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

echo "Configurações de pós-instalação concluídas