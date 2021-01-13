#Abel Esteban i Oriol Llados
#!/usr/bin/bash

RED="\033[31m" #-e quan utilitzem
GREEN="\033[32m"
NC="\033[0m"
player_1=${RED}"X"${NC} #assignem el color i valor que utilitzarem x igualar les posicions i al final retorn NC perque no es posi tot d'aquell color a la prox iteració.
player_2=${GREEN}"O"${NC}
turn=1
game_on=true
welcome_message() {
  echo "========================"
  echo "=== LETS PLAY A GAME ==="
  echo "========================"
  
  read -p "INDICA EL TAMANY DEL TAULER TICTACTOE: " mida
  #https://linuxhint.com/bash_range/ explicació metode seq extret del exercici4
    if [ $mida -gt 3 -a $mida -lt 10 ]; then # a partir de tauler 9 ja es necessitaria posar "%03" 001 
        totalnums="$(seq -f "%02g" 01 $(($mida*$mida)))" #iniciem contador a 00. El 02, 03 etc... servira per a q la sequencia guardi els valors donats en centecimes(03), decimes(02)...
    #elif [$mida -gt 10]; then
	#totalnums="$(seq -f "%03g" 000 $(($mida*$mida)))" #mateixa explicació que a dalt
    else
        totalnums="$(seq -f "%g" 1 $(($mida*$mida)))" #mateixa explicació que a dalt
    fi

    x=0
    for i in $totalnums 
    do
    	moves[$x]=$i
        x=($x+1) #incrementem per al tornar a moves[x] per guardar el seguent
    done
} #a moves guardem tots els valors com es fa al moves original.

#-----------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------

print_board () {
    clear # x no acumular taulers
    echo "---------------------"
    for((i=0; i<$mida; i++))
    do
        s=$(($i*$mida)) #primer valor d cada fila, exemple: 1r valor d la fila 3 seria num 3, multipliquem per la mida i ens porta a moves[9] on tenim 09
        echo -n -e " ${moves[$s]} |" #preparem el color per a més endavant també
        for((x=$(($s+1)); x <$(($s+$mida-1)); x++)) 
	do #valors fins al final d cada fila.
            echo -n -e " ${moves[$x]} |"
        done
        echo -e " ${moves[$x]}" #valor final d cada fila
        echo "---------------------" #salt al arribar al valor de mida pq indica que necessitem nova fila
    done
echo ""

}

#-----------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------

player_pick(){ #NOMÉS S'HA AFEGIT ELS COLORS AL CODI BASE DE LA WEB i he canviat alguns -1 o +1 de moves perque sino no colocava les X be al quadre pero fa que el resultat de check match despres no funcioni.
  if [[ $(($turn % 2)) == 0 ]]
  then
    play=$player_2
    echo -n -e ${GREEN}"PLAYER 2" ${NC} "PICK A SQUARE: "
  else
    echo -n -e ${RED}"PLAYER 1" ${NC} "PICK A SQUARE: "
    play=$player_1
  fi

  read square

  space=${moves[($square-1)]} 

  if [[ ! $square =~ ^-?[0-9]+$ ]] || [[ ! $space =~ ^[0-9]+$  ]]
  then 
    echo -n -e ${GREEN}"NOT A VALID SQUARE" ${NC}
    player_pick
  else
    moves[($square-1)]=$play
    ((turn=turn+1)) 
  fi
  space=${moves[($square-1)]} 
}

#-----------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------

check_winner() { #IGUAL CODI BASE
#VERTICALS
x=0
for ((i=0; i<$mida; i++)) do
        for ((n=0; n<$mida; n++)) do
	a=$(($mida*$n))
	b=$(($n+1))
	c=$(($mida*$b))
	#echo "${moves[$(($i+$a))]}"
	#echo "${moves[$(($i+$c))]}"
        if [ "${moves[$(($i+$a))]}" == "${moves[$(($i+$c))]}" ]; then
            x=$(($x+1)) #igual a x++
	    #echo $x
	else
	    x=0
	fi
	if [ $x == $(($mida-1)) ]; then
		game_on=false
	fi
        if [ $game_on == false ]; then
                if [ "${moves[$(($i+$a))]}" == "$player_1" ]; then
                        echo "Player one wins!"
                    return 
                else
                        echo "Player two wins!"
		        return
                fi
	fi
	done
done

#HORITZONATALS
x=0
game_on=true
for ((n=0; n<$mida; n++)) do	
	for ((i=0; i<$mida; i++)) do
	a=$(($mida*$n))	
	b=$(($a+1))
        if [ "${moves[$(($i+$a))]}" == "${moves[$(($i+$b))]}" ]; then
            x=$(($x+1)) #igual a x++
	else
	    x=0
	fi
	if [ $x == $(($mida-1)) ]; then
		game_on=false
	fi
        if [ $game_on == false ]; then
                if [ "${moves[$(($i+$a))]}" == "$player_1" ]; then
                        echo "Player one wins!"
                    return 
                else
                        echo "Player two wins!"
			return
                fi
	fi
	done
done

#DIAGONAL DESCENDENT	
x=0
for ((i=0; i<$mida; i++)) do
	a=$(($i-1))
	b=$(($mida*$a))
	c=$(($mida*$i))
	p=$(($c+1))
        if [ "${moves[$(($i+$b+$mida))]}" == "${moves[$(($i+$p+$mida))]}" ]; then
            x=$(($x+1)) #igual a x++
	else
	    x=0
	fi
	if [ $x == $(($mida-1)) ]; then
		game_on=false
	fi
        if [ $game_on == false ]; then
                if [ "${moves[$(($i+$b+$mida))]}" == "$player_1" ];then
                        echo "Player one wins!"
                    return 
                else
                        echo "Player two wins!"
		    return
                fi
	fi
done

#DIAGONAL ASCENDENT

for ((i=$mida; i>0; i--)) do
	a=$(($mida-$i))
	b=$(($mida*$a))
	c=$(($a+1))
	d=$(($mida*$c))
        if [ "${moves[$(($i+$b-1))]}" == "${moves[$(($i+$d-2))]}" ]; then 
            x=$(($x+1)) #igual a x++
	else
	    x=0
	fi
	if [ $x == $(($mida-1)) ]; then
		game_on=false
	fi
        if [ $game_on == false ]; then
                if [ "${moves[$(($i+$b-1))]}" == "$player_1" ];then
                        echo "Player one wins!"
                    return 
                else
                        echo "Player two wins!"
		    return
                fi
	fi
	done

}

#-----------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------




welcome_message 
print_board
while $game_on
do
  player_pick
  print_board
  check_winner
    
done


