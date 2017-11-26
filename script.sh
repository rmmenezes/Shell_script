#!/bin/sh

echo “========================================”

echo “Configuração automática de servidor DHCP”

echo “========================================”

echo “”

echo “Verificando se o servidor dhcp está instalado…”

DHCPOK=$(dpkg -l | grep isc-dhcp-server)

if [ -z $DHCPOK ]; then

echo “Instalando isc-dhcp-server…”

apt-get install isc-dhcp-server > /dev/null 2>&1

if [ $? -eq 0 ]; then

“OK!”

else

echo “Não foi possível instalar o serviço isc-dchp-server!”

echo “FIM SCRIPT”

fi

else

echo “OK!”

fi

# Configurando a interface de rede

# Obtendo dados para criar o arquivo de configuração:

echo “Digite o endereço da rede:”

read SUBNET

echo “Digite a máscara da rede:”

read NETMASK

echo “Digite o range de endereços disponíveis na rede separados por vírgula e sem espaço!”

read NETRANGE

NETRANGE=$(echo $NETRANGE | sed -e ‘s/,/ /’)

echo “Informe os endereços de DNS separados por virgula sem espaço!”

read DNS

echo “”

IPGW=$(ifconfig eth0 | grep Bcast | awk -F” ” ‘{print $2}’ | awk -F: ‘{print $2’})

echo “Construino arquivo de configuração…”

# Construindo arquivo de configuração

echo “ddns-update-style none;” > dhcpconfig.auto

echo ” subnet $SUBNET netmask $NETMASK {” >> dhcpconfig.auto

echo ” range dynamic-bootp $NETRANGE;” >> dhcpconfig.auto

echo “” >> dhcpconfig.auto

echo ” option routers $IPGW;” >> dhcpconfig.auto

echo ” option subnet-mask $NETMASK;” >> dhcpconfig.auto

echo ” option domain-name-servers $DNS;” >> dhcpconfig.auto

echo ” default-lease-time 21600;” >> dhcpconfig.auto

echo ” max-lease-time 43200;” >> dhcpconfig.auto

echo “” >> dhcpconfig.auto

echo ” # COMPUTADORES COM IP FIXO:” >> dhcpconfig.auto

# Inserindo IPs fixos

OP=”s”

while [ $OP = s ]; do

echo “Deseja inserir algum IP fixo? (s/N)”

read OP

OP=$(echo $OP | tr [[:upper:]] [[:lower:]])

if [ $OP = s ]; then

echo “Digite o nome do host:”

read HOST

echo “Digite o endereço MAC:”

read MAC

echo “Digite o número de IP:”

read IP

echo ” host $HOST {” >> dhcpconfig.auto

echo ” hardware ethernet $MAC;” >> dhcpconfig.auto

echo ” fixed-address $IP;” >> dhcpconfig.auto

echo ” }” >> dhcpconfig.auto

fi

done

# Finalizando o arquivo de configuração

echo “”

echo ” }” >> dhcpconfig.auto

echo “Finalizando o arquivo de configuração…”

sleep 5

echo “O arquivo de configuração foi criado em $(pwd)/dhcpconfig.auto”

# Substituindo o arquivo de configuração original

echo “Deseja substituir o arquivo /etc/dhcp/dhcpd.conf? (s/N)”

read OP

OP=$(echo $OP | tr [[:upper:]] [[:lower:]])

if [ $OP = s ]; then

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bkp

mv $(pwd)/dhcpconfig.auto /etc/dhcp/dhcpd.conf

fi

# Reiniciando o serviço

echo “Reiniciando o servdidor dhcp…”

invoke-rc.d isc-dhcp-server restart
