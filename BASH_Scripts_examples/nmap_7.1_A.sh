#!/bin/bash

all () {
echo " Type subnet mask for scanning IP and HOSTS available... (example > 192.168.1.0/24)"
read
nmap -sn $REPLY
}

target () 
{
echo "Type subnet mask for scanning open TCP ports... (example > 192.168.1.0/24)"
read
nmap  -sT $REPLY
}

helpFunction()
{
   echo ""
   echo ""
   echo "     nmap.sh help"
   echo "    *********************************************************************"
   echo -e "    -a     # Displays the all IP addresses of all hosts in the current subnet"
   echo -e "    -t     # Displays a list of open system TCP ports in the current subnet"
   echo ""
   echo ""
   exit 1 # Exit script after printing help
}

if [ "$*" == "" ]; then
    helpFunction
    exit 1
fi

echo
while [ -n "$1" ]
do
case "$1" in
-a) all ;;
-t) target ;;
*) echo "$1 is not an option" ;;
esac
shift
done

