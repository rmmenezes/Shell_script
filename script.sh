#!/bin/bash

echo "----------------------------"
echo "REDES I COM MININET 2017"
echo "----------------------------"
echo "Rafael Menezes RA:1817485"
echo "Jonas Felipe   RA:1817450"
echo "----------------------------"


echo "Insira o numero de maquinas na rede"
read qtd_PC

echo "Instalar DHCPD-SERVER? (Y/N)"
read conf

#Se minha resposta for Sim! vou instalar DHCPD-Server
if [conf == Y]{
	apt-get install dhcp3-server
}

echo "Instalar Interface Xinit Flwm? (Y/N)"
read conf

#Se minha resposta for Sim! vou instalar DHCPD-Server
if [conf == Y]{
	apt-get install xinit flwm
	startx
}

echo "----------------------------"
echo "Configurando DHCP.CONF"
echo "----------------------------"

echo "Insira o IP do servidor Principal:"
read ipServer

echo "Insira a Mascara de Rede:"
read mask

echo "Insira o range(1) de IPs da Rede:"
read range1

echo "Insira o range(2) de IPs da Rede:"
read range2

echo "Insira o endereço de broadcast:"
read broadcast

#Configurando subnet
echo subnet $ipServer netmask $mask {
		range $range1 $range2;
		option broadcast-address $broadcast;
	} >>  /etc/dhcp/dhcpd.conf

echo "----------------------------"
echo "Criando topologia"
echo "----------------------------"

echo "Insira o numero de Maquinas na Rede:"
read qtd_PC

#Cria uma topologia 1 SW e qtd_PC Computadores e faz os LINKES
mn --topo=single,qtd_PC 

echo "Comando magico"
ifconfig h1-eth0 ipServer

echo "Startando o dhcp"
dhcpd -cf /etc/dhcp/dhcpd.conf
