#!/bin/bash
if [ -f "/root/usuarios.db" ]
	then
		echo ""
		echo "Criando backup..."
		echo ""
		tar cvf /root/backup.vps /root/usuarios.db /etc/shadow /etc/passwd /etc/group /etc/gshadow
		echo ""
		echo "Arquivo /root/backup.vps criado com sucesso."
		echo ""
	else
		echo ""
		echo "Criando backup..."
		echo ""
		tar cvf /root/backup.vps /etc/shadow /etc/passwd /etc/group /etc/gshadow
		echo ""
		echo "Arquivo /root/backup.vps criado com sucesso."
		echo ""
	fi
