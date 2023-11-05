#! /bin/bash
echo "--------------------------
User Name: jineunbi
Student Number: 12223825
[ MENU ]
1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item'
3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
4. Delete the 'IMDb URL' from 'u.item'
5. Get the data about users from 'u.user'
6. Modify the format of 'release date' in 'u.item'
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit
--------------------------"
while true
do
	read -p "Enter your choice [ 1-9 ] " choice
	if [ $choice -eq 9 ]; then
		echo "Bye!"
		break
	elif [ $choice -eq 1 ]; then
		echo''
		read -p "Please enter 'movie id' (1~1682):" id
		echo''
		cat u.item | awk -F\| -v id="$id" '$1==id {print $0}'
	elif [ $choice -eq 2 ]; then
		echo''
		read -p "Do you want to get data of 'action' genre movies from 'u.item'? (y/n):" answer
		if [ $answer = "y" ]; then
		 	echo''
			cat u.item | awk -F\| '$7==1 {print $1,$2}' | head -n 10
		fi
	elif [ $choice -eq 3 ]; then
		echo''
 		read -p "Please enter the 'movie id' (1~1682):" id
		echo''
		cat u.data | awk -v id="$id" '$2==id {sum+=$3; cnt++} END {printf "average rating of %d: %.5f\n", id, (sum/cnt)+0.000005}'
	elif [ $choice -eq 4 ]; then
		echo''
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" answer
		echo''
		if [ $answer = "y" ]; then
			cat u.item | sed -E 's/http[^|]*\|/|/g' | head -n 10
		fi
	elif [ $choice -eq 5 ]; then
		echo''
		read -p "Do you want to get the data about users from 'u.user'?(y/n):" answer
		echo''
		if [ $answer = "y" ]; then
			cat u.user | awk -F\| ' { if ($3 == "M" ) print "user " $1 " is " $2 " years old male " $4; else print "user " $1 " is " $2 " years old female " $4 }' | head -n 10
		fi
	elif [ $choice -eq 6 ]; then
		echo''
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" answer
		echo''
		if [ $answer = "y" ]; then
			cat u.item | sed -E -e 's/([0-9]{2})-Jan-([0-9]{4})/\201\1/g' \
					    -e 's/([0-9]{2})-Feb-([0-9]{4})/\202\1/g' \
					    -e 's/([0-9]{2})-Mar-([0-9]{4})/\203\1/g' \
					    -e 's/([0-9]{2})-Apr-([0-9]{4})/\204\1/g' \
                                            -e 's/([0-9]{2})-May-([0-9]{4})/\205\1/g' \
					    -e 's/([0-9]{2})-Jun-([0-9]{4})/\206\1/g'  \
					    -e 's/([0-9]{2})-Jul-([0-9]{4})/\207\1/g' \
					    -e 's/([0-9]{2})-Aug-([0-9]{4})/\208\1/g' \
					    -e 's/([0-9]{2})-Sep-([0-9]{4})/\209\1/g' \
					    -e 's/([0-9]{2})-Oct-([0-9]{4})/\210\1/g' \
					    -e 's/([0-9]{2})-Nov-([0-9]{4})/\211\1/g' \
					    -e 's/([0-9]{2})-Dec-([0-9]{4})/\212\1/g' | tail -n 10
		fi
	elif [ $choice -eq 7 ]; then
		echo''
	   	read -p "Please enter the 'user id' (1~943):" id
	   	echo''
           	cat u.data | sort -n -k2 | awk -v id="$id" '$1==id {print $2}' >> sortedmovieid.txt
	  	p=$( cat u.data| sort -n -k2 | awk -v id="$id" '$1==id {printf "%s|", $2}')
	   	echo "${p%|}"
		echo ''
		cnt=0
		for i in $(<sortedmovieid.txt); do
			cat u.item | awk -F\| -v i="$i" '$1==i {print $1 "|" $2}'
			((cnt++))
			if [ $cnt -eq 10 ]; then
				break
			fi
		done
		rm sortedmovieid.txt
	elif [ $choice -eq 8 ]; then
		echo''
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" answer
		if [ $answer = "y" ]; then		 
			echo''
			cat u.user | awk -F\| '$4=="programmer" && 20<=$2 && $2<=29 {print $1}' >> programmer_userid.txt
			awk ' FILENAME=="programmer_userid.txt" { users[$1]=$1 } FILENAME == "u.data" && $1 in users {total[$2]+=$3; count[$2]++} END { for(i=1; i<=1682; i++) if (count[i]>0) { printf "%d %.5f\n", i, total[i]/count[i]; }}' programmer_userid.txt u.data | awk '{sub(/\.?0*$/,"",$2); print}' >>result.txt
			cat result.txt
			rm programmer_userid.txt
			rm result.txt
			
		fi
	fi
	echo ''
	
done

