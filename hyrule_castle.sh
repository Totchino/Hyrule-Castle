#!/bin/bash

source ./fonctions.sh

clear
coin=0

#Affichage du menu et des différents modes de jeu
menu
win=0
lose=0
if [[ $m == 1 ]]; then
menu_versus
elif [[ $m == 2 ]]; then
clear
alerte_maintenance
else
echo "invalid option $REPLY"
read -n 1 -s -r -p "    === Press any key to return to the menu ==="
clear
menu
fi

