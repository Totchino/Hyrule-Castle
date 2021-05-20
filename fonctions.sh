#!/bin/bash

##### fonctions Random (entre 1 et 5) #####

Random() {
b=10
while [[ $b -le 0 ]] || [[ $b -ge 6 ]]; do
b=$(($RANDOM%10))
done
}

##### Choix du héros (avec un numéro choisi par l'utilisateur) #####

heros_choice() {
clear

first_line=0
echo -e "=====================================================\n\n"
echo -e "\tChoississez un numéro entre 1 et 5."
echo -e "\n\n====================================================="
a=0
read a

while [[ $a -le 0 ]] || [[ $a -ge 6 ]]; do
echo "On vous a dit entre 1 et 5 faut vous faire un dessin ?"
read a
done

while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
    if [[ first_line -ne 0 ]]; then
        if [[ $id -eq $a ]]; then
    Heroes=( ['id']="$id" ['name']="$name" ['hp']="$hp" ['mp']="$mp" ['str']="$str" ['int']="$int" ['def']="$def" ['res']="$res" ['spd']="$spd" ['luck']="$luck" ['race']="$race" ['class']="$class" ['rarity']="$rarity")
        fi
    else
        first_line=1
    fi
done < fichier.csv/players.csv

B=$(echo "${Heroes["name"]}" | tr [:lower:] [:upper:])

echo -e "Votre personnage est \e[32m$B\e[0m.\n"
read -n 1 -s -r -p "    === Press any key to continue ==="
clear
}

##### Choix de l'ennemi #####

enemy_choice() {
echo -e "=====================================================\n"
echo -e "   Il est heure de savoir qui sera votre ennemi."
echo -e "   Choississez un numéro entre 1 et 12."
echo -e "\n\n====================================================="

b=0
read b
while [[ $b -le 0 ]] || [[ $b -ge 13 ]]; do
echo "Me rends pas fou man."
read b
done

clear

first_line=0
while IFS=',' read -r id name hp mp str int def res spd luck race class rarity; do
    if [[ first_line -ne 0 ]]; then
        if [[ $id -eq $b ]]; then
    Enemy=( ['id']="$id" ['name']="$name" ['hp']="$hp" ['mp']="$mp" ['str']="$str" ['int']="$int" ['def']="$def" ['res']="$res" ['spd']="$spd" ['luck']="$luck" ['race']="$race" ['class']="$class" ['rarity']="$rarity")
        fi
    else
        first_line=1
    fi
done < fichier.csv/enemies.csv

C=$(echo "${Enemy["name"]}" | tr [:lower:] [:upper:])

echo -e "=====================================================\n\n"
echo -e "Votre ennemi est \e[31m$C\e[0m."
echo -e "\n\n====================================================="
read -n 1 -s -r -p "    === Press any key to continue ==="
clear

}

##### Display Versus (affiche les protagonistes du combat) #####

display_versus() {
echo -e "=====================================================\n"
echo -e "   \e[32m$B\e[0m    
                vs
                        \e[31m$C\e[0m\n" 
echo -e "====================================================="
read -n 1 -s -r -p "   === Press any key to continue ==="
clear
}              

##### DisplayHP (affiche la barre de vie) #####

HP_barre() {
    echo -n "HP: " 
    hp_max=$1
    trait=$(($1 - $2))
        for i in $(seq 1 $2); do
    echo -n "I"
        done
        for j in $(seq 1 $trait); do
    echo -n "_"
        done
    echo -n -e " $2 / $1\n\n"
} 

##### Liste des actions en combat #####

Combat() {

while [[ true ]]; do
    
    PS3='Make a choice: '
options=("Attack" "Heal" "Abandonner")
select opt in "${options[@]}"
do
    case $opt in
        "Attack")
            Heroes_attack
	        Enemy_attack 
            read -n 1 -s -r -p "    === Press any key to continue ===" 
            clear
            display_screen
	        ;;
         "Heal")
            Heroes_heal
            read -n 1 -s -r -p "    === Press any key to continue ==="
            clear
            display_screen
            ;;
        "Abandonner")
            clear
	        echo -e "${Heroes["name"]} prend la fuite..\n"
            read -sp "  === Press ENTER to get out the game like a wimp === "
            clear
            echo "La fuite est impossible."
            echo -e "\e[32m${Heroes["name"]}\e[0m s'est blessé en tentant de fuir, il lui reste 1 HP.
                                        Bon Chance.\n"
            hp_heroes=$(( $hp_heroes - $hp_heroes + 1))
            read -n 1 -s -r -p "    === Press any key to continue ==="
            clear
            display_screen
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
done
}

###### Interactions Combat ######

Heroes_attack() {
    hp_enemy=$(( $hp_enemy - ${Heroes["str"]} ))
    if [[ hp_enemy -le 0 ]]; then
    hp_enemy=0
    clear
    congratulations
    win=1
    display_screen
    coin=$(($coin + 1))
    echo -e "You receive a coin (total: $coin)"
    read -n 1 -s -r -p "    === Press any key to RESTART a game ==="
    clear
    menu
    fi
}

Enemy_attack() {
    hp_heroes=$(( $hp_heroes - ${Enemy["str"]} ))
    if [[ hp_heroes -gt 0 ]]; then
    echo "------------------------------"
    echo -e "\e[32m${Heroes["name"]}\e[0m \e[3mattaque et inflige ${Heroes["str"]} dégats!\e[0m"
    echo -e "\e[31m${Enemy["name"]}\e[0m \e[3mattaque et inflige ${Enemy["str"]} dégats!\e[0m"
    echo "------------------------------"
        else
    lose=1
    display_screen
    echo -e "\e[31m${Enemy["name"]}\e[0m \e[3mattaque et inflige ${Enemy["str"]} dégats!\e[0m"
    clear
    echo -e "=====================================================\n\n"
    echo "La honte, tu es mort. (c'était un niveau facile)"
    echo -e "\n\n====================================================="
    coin=$(($coin - 3))
    echo -e "You lost three coins (total: $coin)"
    read -n 1 -s -r -p "    === Press any key to RETRY ==="
    clear
    menu
    fi

}

Heroes_heal() {
    hp_heroes=$(( $hp_heroes + ( ${Heroes["hp"]} /2) ))
    if [[ $hp_heroes -gt ${Heroes["hp"]} ]]; then
    hp_heroes=${Heroes["hp"]}
    echo -e "\e[32m${Heroes["name"]}\e[0m \e[3ma récupéré toute sa vie!\e[0m"
    else
    echo -e "\e[32m${Heroes["name"]}\e[0m \e[3ma récupéré $((${Heroes["hp"]} /2)) HP!\e[0m"
    fi
}


###### Display screen ######

display_screen() {

while [[ $win == 0 ]] && [[ $lose == 0 ]]; do  
echo -e "\t============ Fight ============ 
|\e[31m${Enemy["name"]}\e[0m|"
HP_barre ${Enemy["hp"]} $hp_enemy
echo -e "|\e[32m${Heroes["name"]}\e[0m|"
HP_barre ${Heroes["hp"]} $hp_heroes
echo -e "\e[3mYou encounter a ${Enemy["name"]}\e[0m"
Combat
done
}

###### Choix des protagonistes ######

menu_versus() {
unset Enemy
unset Heroes

declare -A Enemy
declare -A Heroes

heros_choice
enemy_choice
display_versus

#Initialisation caractéristiques 

hp_enemy=${Enemy["hp"]}
hp_heroes=${Heroes["hp"]}

display_screen
read -sp "[Press ENTER to get out the game like a wimp]"
clear

}

###### Congratulations message ######

congratulations() {
    echo -e "=====================================================\n\n"
    echo -e " \e[1mCongratulations\e[0m, you beat this monster."
    echo -e "\n\n====================================================="
}

###### Menu du jeu ######

menu() {

echo -e "=====================================================\n\n"
echo -e "\tBienvenue sur Hyrule Rumble."
echo -e "\n\n====================================================="
echo -e "You have $coin coin"
read -n 1 -s -r -p "    === Press any key to continue ==="
clear
echo -e "=====================================================\n\n"
echo -e "\tVeuillez choisir un mode de jeu."
echo -e "\n\n====================================================="
echo -e "You have $coin coin"
read -n 1 -s -r -p "    === Press any key to continue ==="
clear
echo -e "=====================================================\n\n"
echo -e "\t1.Mode versus       2.Base Game                        "
echo -e "\n\n====================================================="
read m

}

###### Message maintenance ######

alerte_maintenance() {
echo -e "=====================================================\n\n"
echo -e "Veuillez-nous excuser le mode Base Game est en maintenance."                 
echo -e "\n\n====================================================="
}