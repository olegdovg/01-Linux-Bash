#!/bin/bash
# task_A.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ $# -eq 0 ] || [ $# -lt 1 ] 
  then
    echo -e "[${RED}ERROR${NC}] invalid option"
    echo "Usage"
    echo "task_A <options>"
    echo

    echo "Options"
    echo "--all    - displays the IP addresses and symbolic names of all hosts in the current subnet"
    echo "--target - displays a list of open system TCP ports."   
    exit
elif [ $1 == "--all" ]
  then
	lip=$(bash getLan.sh enp0s3)
	echo -e "Скануємо мережу на інтерфейсі ${GREEN}enp0s3${NC} - ${lip}"
    echo 
    echo "Знайдено активні пристрої"
	nmap -sn $lip | awk '/Nmap scan/{ print $NF}'
  	exit
else
	lip=$(bash getLan.sh enp0s3)
	echo -e "Скануємо мережу на інтерфейсі ${GREEN}enp0s3${NC} - ${lip}"
    echo 
    echo "Знайдено активні пристрої та відкриті порти "
	sip=$(nmap -sV $lip -oG nmap_output)
	cat nmap_output | grep Ports
	#echo ${inip[0]}
  	exit  
fi

