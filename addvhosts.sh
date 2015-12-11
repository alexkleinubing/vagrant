#!/bin/bash
# Set default parameters
# addvhost create|delete domain.dev /var/www/domain
action=$1
domain=$2
rootdir=$3
defaultDir='/var/www/'
sitesEnabled='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
hostsFileEdit=true
hostsFile='/etc/hosts'
hostsFileIP='192.168.100.101'

owner=$(who am i | awk '{print $1}')
ESC="\033"
AZUL=36
AMARELO=33
VERMELHO=31
VERDE=32
CORPADRAO=0

function mensagem() {
	case $2 in
		info)
			COR=$AZUL ;;
		alerta)
			COR=$AMARELO ;;
		perigo)
			COR=$VERMELHO ;;
		sucesso)
			COR=$VERDE ;;
		*)
			COR=$CORPADRAO ;;
	esac
	echo -e "${ESC}[${COR}m${1}${ESC}[${CORPADRAO}m"
}

function colorize() {
	if [ -z $2 ]; then
		COR=$CORPADRAO
	elif [ -z ${$2} ]; then
		COR=${$2}
	fi
	return -e "${ESC}[${COR}m${1}${ESC}[${CORPADRAO}m"
}

function define_rootdir() {
	while [ -z $rootdir ]; do
		echo "[${action} ${domain}] Informe o diretório root do projeto (${defaultDir}${domain}): "
		read choiceAction
		if [ -z $choiceAction ]; then
			rootdir="${defaultDir}${domain}"
		else
			rootdir=$choiceAction
		fi
			choiceAction=''
	done
	mensagem "Diretório Root: ${rootdir}" 'info'
}

function adicionar() {
	define_rootdir
	echo "
	<VirtualHost *:80>
		ServerName $domain
		ServerAlias www.$domain
	
		DocumentRoot "$rootdir"
	
		<Directory "$rootdir">
			Options Indexes FollowSymLinks MultiViews
			AllowOverride All
			Order allow,deny
			Allow from all
		</Directory>
	</VirtualHost>
	" > $sitesAvailable$domain.conf
	mensagem "Adicionado: $sitesAvailable${domain}.conf" 'info'
	ln -s $sitesAvailable$domain.conf $sitesEnabled
	mensagem "Adicionado: $sitesEnabled${domain}.conf" 'info'

	if [ $hostsFileEdit=true ]; then
		echo -e "$hostsFileIP $domain" >> $hostsFile
		mensagem "Adicionado: $hostsFileIP $domain -> $hostsFile" 'info'
	fi
	sudo service apache2 restart
}

function apagar() {
	echo 'apagar'
}

if [ "$(whoami)" != 'root' ]; then
	mensagem "Você não tem permissão para executar $0 como um usuário não-root. Use sudo." 'alerta'
	exit 1;
fi

while [ "$action" != 'create' -a "$action" != 'delete' ]; do
	echo "Você deseja criar ou apagar um virtual host? (CREATE/delete): "
	read choiceAction
	case $choiceAction in
		create) 
			action=$choiceAction ;;
		delete) 
			action=$choiceAction ;;
		*) 
			action=''
			mensagem 'Opção inválida.' 'alerta'
			;;
	esac
	choiceAction=''
done

while [ -z $domain ]; do
	echo "[${action}] Informe o domínio (ex. meuprojeto.dev): "
	read choiceAction
	if [ -z $choiceAction ]; then
		mensagem 'domínio inválido.' 'alerta'
	else
		domain=$choiceAction
	fi
		choiceAction=''
done

case $action in
	create)	adicionar ;;
	delete)	apagar ;;
	*) mensagem 'Erro critico. A operação foi cancelada.' 'perigo'
esac


echo $action
echo $domain
echo $rootdir
