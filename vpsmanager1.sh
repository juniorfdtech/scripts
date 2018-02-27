#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 2.0.2" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irÃƒÂ¡:" ; echo ""
echo "Ã¢â€”Â Instalar e configurar o proxy squid nas portas 80, 3128, 8080 e 8799" ; echo "  para permitir conexÃƒÂµes SSH para este servidor"
echo "Ã¢â€”Â Configurar o OpenSSH para rodar nas portas 22 e 443"
echo "Ã¢â€”Â Instalar um conjunto de scripts como comandos do sistema para o gerenciamento de usuÃƒÂ¡rios" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Ao utilizar o 'VPS Manager 2.0' vocÃƒÂª concorda com os seguintes termos de uso:"
echo ""
echo "1. VocÃƒÂª pode:"
echo "a. Instalar e usar o 'VPS Manager 2.0' no(s) seu(s) servidor(es)."
echo "b. Criar, gerenciar e remover um nÃƒÂºmero ilimitado de usuÃƒÂ¡rios atravÃƒÂ©s desse conjunto de scripts."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. VocÃƒÂª nÃƒÂ£o pode:"
echo "a. Editar, modificar, compartilhar ou redistribuir (gratuitamente ou comercialmente)"
echo "esse conjunto de scripts sem autorizaÃƒÂ§ÃƒÂ£o do desenvolvedor."
echo "b. Modificar ou editar o conjunto de scripts para fazer vocÃƒÂª parecer o desenvolvedor dos scripts."
echo ""
echo "3. VocÃƒÂª aceita que:"
echo "a. O valor pago por esse conjunto de scripts nÃƒÂ£o inclui garantias ou suporte adicional,"
echo "porÃƒÂ©m o usuÃƒÂ¡rio poderÃƒÂ¡, de forma promocional e nÃƒÂ£o obrigatÃƒÂ³ria, por tempo limitado,"
echo "receber suporte e ajuda para soluÃƒÂ§ÃƒÂ£o de problemas desde que respeite os termos de uso."
echo "b. O usuÃƒÂ¡rio desse conjunto de scripts ÃƒÂ© o ÃƒÂºnico resposÃƒÂ¡vel por qualquer tipo de implicaÃƒÂ§ÃƒÂ£o"
echo "ÃƒÂ©tica ou legal causada pelo uso desse conjunto de scripts para qualquer tipo de finalidade."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. VocÃƒÂª concorda que o desenvolvedor nÃƒÂ£o se responsabilizarÃƒÂ¡ pelos:"
echo "a. Problemas causados pelo uso dos scripts distribuÃƒÂ­dos sem autorizaÃƒÂ§ÃƒÂ£o."
echo "b. Problemas causados por conflitos entre este conjunto de scripts e scripts de outros desenvolvedores."
echo "c. Problemas causados por ediÃƒÂ§ÃƒÂµes ou modificaÃƒÂ§ÃƒÂµes do cÃƒÂ³digo do script sem autorizaÃƒÂ§ÃƒÂ£o."
echo "d. Problemas do sistema causados por programas de terceiro ou modificaÃƒÂ§ÃƒÂµes/experimentaÃƒÂ§ÃƒÂµes do usuÃƒÂ¡rio."
echo "e. Problemas causados por modificaÃƒÂ§ÃƒÂµes no sistema do servidor."
echo "f. Problemas causados pelo usuÃƒÂ¡rio nÃƒÂ£o seguir as instruÃƒÂ§ÃƒÂµes da documentaÃƒÂ§ÃƒÂ£o do conjunto de scripts."
echo "g. Problemas ocorridos durante o uso dos scripts para obter lucro comercial."
echo "h. Problemas que possam ocorrer ao usar o conjunto de scripts em sistemas que nÃƒÂ£o estÃƒÂ£o na lista de sistemas testados."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " VocÃƒÂª nÃƒÂ£o digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Uma base de dados de usuÃƒÂ¡rios ('usuarios.db') foi encontrada!"
	echo "Deseja mantÃƒÂª-la (preservando o limite de conexÃƒÂµes simultÃƒÂ¢neas dos usuÃƒÂ¡rios)"
	echo "ou criar uma nova base de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Manter Base de Dados Atual"
	echo "[2] Criar uma Nova Base de Dados"
	echo "" ; tput sgr0
	read -p "OpÃƒÂ§ÃƒÂ£o?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Deseja ativar a compressÃƒÂ£o SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuraÃƒÂ§ÃƒÂ£o automÃƒÂ¡tica" ; echo "" ; tput sgr0
sleep 3
apt-get update -y
apt-get upgrade -y
rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda > /dev/null
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh > /dev/null
apt-get install squid3 bc screen nano unzip dos2unix wget -y
killall apache2
apt-get purge apache2 -y
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
if [ -d "/etc/squid3/" ]
then
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/sqd1 -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/sqd3 -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/payload.txt -O /etc/squid3/payload.txt
	echo " " >> /etc/squid3/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/addhost -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/alterarsenha -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/criarusuario -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/delhost -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/expcleaner -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/mudardata -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/remover -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/sshlimiter -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/alterarlimite -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/ajuda -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/QualityNet/squid3/master/sshmonitor -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid3" ]
	then
		service squid3 reload > /dev/null
	else
		/etc/init.d/squid3 reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://raw.githubusercontent.com/QualityNet/squid/master/sqd1 -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://raw.githubusercontent.com/QualityNet/squid/master/sqd3 -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	wget https://raw.githubusercontent.com/QualityNet/squid/master/payload.txt -O /etc/squid/payload.txt
	echo " " >> /etc/squid/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
	wget https://raw.githubusercontent.com/QualityNet/squid/master/addhost -O /bin/addhost
	chmod +x /bin/addhost
	wget https://raw.githubusercontent.com/QualityNet/squid/master/alterarsenha -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget https://raw.githubusercontent.com/QualityNet/squid/master/criarusuario -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget https://raw.githubusercontent.com/QualityNet/squid/master/delhost -O /bin/delhost
	chmod +x /bin/delhost
	wget https://raw.githubusercontent.com/QualityNet/squid/master/expcleaner -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget https://raw.githubusercontent.com/QualityNet/squid/master/mudardata -O /bin/mudardata
	chmod +x /bin/mudardata
	wget https://raw.githubusercontent.com/QualityNet/squid/master/remover -O /bin/remover
	chmod +x /bin/remover
	wget https://raw.githubusercontent.com/QualityNet/squid/master/sshlimiter -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget https://raw.githubusercontent.com/QualityNet/squid/master/alterarlimite -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget https://raw.githubusercontent.com/QualityNet/squid/master/ajuda -O /bin/ajuda
	chmod +x /bin/ajuda
	wget https://raw.githubusercontent.com/QualityNet/squid/master/sshmonitor -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
fi
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid Instalado e rodando nas portas: 80, 3128, 8080 e 8799" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH rodando nas portas 22 e 443" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Scripts para gerenciamento de usuÃƒÂ¡rio instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Leia a documentaÃƒÂ§ÃƒÂ£o para evitar dÃƒÂºvidas e problemas!" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver os comandos disponÃƒÂ­veis use o comando: ajuda" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1
