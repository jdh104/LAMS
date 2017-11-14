#!/usr/bin/env bash
## LARRY'S ARCADE MANAGEMENT SYSTEM
VERSION=v1.0.3

clear

this=""
name=""
nam1=""
nam2=""
entry=""
comm=""
opt=""
newname=""
results=""
t1=0
t2=0
tickets=0
add=0
subtract=0
i=0
go=0
p=""

d=`pwd`

if [ ! -d "accounts" ]
then
	mkdir "accounts"
fi
if [ ! -d "history" ]
then
	mkdir "history"
fi
if [ ! -d "tmp" ]
then
	mkdir "tmp"
fi

while [ "$opt" != "0" ]
do
	clear
        echo ""
        echo "LARRY'S ARCADE MANAGEMENT SYSTEM"
        echo "------------------------------------------------"
	echo "0:  Quit and ShutDown"
	echo "1:  Create new account"
	echo "2:  Search for an account"
	echo "3:  View transaction history of account"
	echo "4:  View number of tickets in an account"
	echo "5:  Add tickets to account"
	echo "6:  Remove tickets from account"
	echo "7:  Merge two accounts"
	echo "99: View info"
	echo "------------------------------------------------"
	echo ""
	read -p "Select option: " opt
	echo ""

	if [ "$opt" = "1" ]
	then
		read -p "Full name (first middle last): " newname
		declare -u newname
		newname="$newname"
		echo ""
		if [ -f accounts/"$newname" ]
		then
			echo "Account already exists"
			echo "$newname currently has `cat accounts/"$newname"` tickets"
		else
			read -p "Set number of tickets: " tickets
			echo "$tickets" > accounts/"$newname"
			echo "Account created on "`date "+%A, %B %d, %Y at %r"` > history/"$newname".hist
			echo " ^ Started with $tickets tickets" >> history/"$newname".hist
			echo "" >> history/"$newname".hist

			if [ -f accounts/"$newname" ]
			then
				echo "Account successfully created"
			fi
		fi
	elif [ "$opt" = "2" ]
	then
		read -p "Search: " search
		declare -u search
		search="$search"
		echo ""
		cd accounts
		ls *"$search"* &> "$d"/tmp/.trash
		results="`cat "$d"/tmp/.trash`"
		if [ "$results" = "ls: cannot access *$search*: No such file or directory" ]
		then
			echo "No Accounts Found"
		else
			echo "Found Accounts:"
			ls *"$search"*
		fi
		cd "$d"
	elif [ "$opt" = "3" ]
	then
		go=1
		while [ "$go" = 1 ]
		do
			read -p "Name: " search
			declare -u search
			search="$search"
			echo ""
			cd accounts
			ls *"$search"* &> "$d"/tmp/.trash
			results="`cat "$d"/tmp/.trash`"
			if [ -f "$d"/history/"$search".hist ]
			then
				cat "$d"/history/"$search".hist
				echo "$search currently has `cat "$search"` tickets"
				go=0
			elif [ "$results" != "ls: cannot access *$search*: No such file or directory" ]
			then
				echo "Accounts found: "
				ls *"$search"*
			else
				echo "Account not found"
				go=0
			fi
			cd "$d"
		done
	elif [ "$opt" = "4" ]
	then
		go=1
		while [ "$go" = 1 ]
		do
			read -p "Name: " search
			declare -u search
			search="$search"
			echo ""
			cd accounts
			ls *"$search"* &> "$d"/tmp/.trash
			results="`cat "$d"/tmp/.trash`"
			if [ -f "$search" ]
			then
				tickets=`cat "$search"`
				echo "$search currently has $tickets tickets"
				go=0
			elif [ "$results" != "ls: cannot access *$search*: No such file or directory" ]
			then
				echo "Accounts found: "
				if [ ${#results} -lt 500 ]
				then
					for this in *"$search"*
					do
						echo "$this: "`cat "$this"`
					done
					go=0
				else
					ls *"$search"*
				fi
			else
				echo "Account not found"
				go=0
			fi
			cd "$d"
		done
	elif [ "$opt" = "5" ]
	then
		go=1
		while [ "$go" = 1 ]
		do
			read -p "Name: " name
			declare -u name
			name="$name"
			echo ""
			cd accounts
			ls *"$name"* &> "$d"/tmp/.trash
			results="`cat "$d"/tmp/.trash`"
			if [ -f "$name" ]
			then
				tickets=`cat "$name"`
				echo "$name currently has $tickets tickets"
				read -p "How many to add? " add
				tickets=$((tickets+add))
				echo "$tickets" > "$name"
				echo `date "+%A, %B %d, %Y at %r"`": +$add""=$tickets" >> "$d"/history/"$name".hist
				echo "$name currently has $tickets tickets"
				go=0
			elif [ "$results" != "ls: cannot access *$name*: No such file or directory" ]
			then
				echo "Accounts found: "
				ls *"$name"*
			else
				echo "Account not found"
				go=0
			fi
			cd "$d"
		done
	elif [ "$opt" = "6" ]
	then
		go=1
		while [ "$go" = 1 ]
		do
			read -p "Name: " name
			declare -u name
			name="$name"
			echo ""
			cd accounts
			ls *"$name"* &> "$d"/tmp/.trash
			results="`cat "$d"/tmp/.trash`"
			if [ -f "$name" ]
			then
				tickets=`cat "$name"`
				echo "$name currently has $tickets tickets"
				read -p "How many to subtract? " subtract
				if [ "$subtract" -le "$tickets" ]
				then
					tickets=$((tickets-subtract))
					echo "$tickets" > "$name"
					echo `date "+%A, %B %d, %Y at %r"`": -$subtract""=$tickets" >> "$d"/history/"$name".hist
				fi
				echo "$name currently has $tickets tickets"
				go=0
			elif [ "$results" != "ls: cannot access *$name*: No such file or directory" ]
			then
				echo "Accounts found: "
				ls *"$name"*
			else
				echo "Account not found"
				go=0
			fi
			cd "$d"
		done
	elif [ "$opt" = "7" ]
	then
		go=1
		while [ "$go" = 1 ]
		do
			cd "$d"
			read -p "Account 1: " nam1
			declare -u nam1
			nam1="$nam1"
			cd accounts
			ls *"$nam1"* &> "$d"/tmp/.trash
			results="`cat "$d"/tmp/.trash`"
			if [ -f "$nam1" ]
			then
				while [ "$go" = 1 ]
				do
					read -p "Account 2: " nam2
					declare -u nam2
					nam2="$nam2"
					echo ""
					ls *"$nam2"* &> "$d"/tmp/.trash
					results="`cat "$d"/tmp/.trash`"
					if [ -f "$nam2" ]
					then
						stop=0
						t1="`cat "$nam1"`"
						t2="`cat "$nam2"`"
						tickets=$((t1+t2))
						echo ""
						echo "$nam1 has $t1 tickets"
						echo "$nam2 has $t2 tickets"
						echo "Together they have $tickets tickets"
						echo ""
						while [ "$stop" = 0 ]
						do
							read -p "New Account Name: " name 
							declare -u name
							name="$name"
							if [ -f "$name" -a "$name" != "$nam1" -a "$name" != "$nam2" ]
							then
								echo "Account already exists"
							else
								stop=1
							fi
						done
						echo "0" > "$nam1"
						echo "0" > "$nam2"
						echo "$tickets" > "$name"
						if [ ! -f "$d"/history/"$name".hist ]
						then
							echo "Account created on `date "+%A, %B %d, %Y at %r"`" > "$d"/history/"$name".hist
							echo " ^ Started with $tickets tickets" >> "$d"/history/"$name".hist
						fi
						echo `date "+%A, %B %d, %Y at %r"`":" >> "$d"/history/"$name".hist
						echo " ^ Merged $nam1 and $nam2: $t1+$t2=$tickets" >> "$d"/history/"$name".hist
						if [ "$nam1" != "$name" ]
						then
							echo `date "+%A, %B %d, %Y at %r"`":" >> "$d"/history/"$nam1".hist
							echo " ^ Merged with $nam2" >> "$d"/history/"$nam1".hist
							echo " ^ New Account: $name" >> "$d"/history/"$nam1".hist
							echo "                                             =0" >> "$d"/history/"$nam1".hist
						fi
						if [ "$nam2" != "$name" ]
						then
							echo `date "+%A, %B %d, %Y at %r"`":" >> "$d"/history/"$nam2".hist
							echo " ^ Merged with $nam1" >> "$d"/history/"$nam2".hist
							echo " ^ New Account: $name" >> "$d"/history/"$nam2".hist
							echo "                                             =0" >> "$d"/history/"$nam2".hist
						fi
						go=0
					elif [ "$results" != "ls: cannot access *$name*: No such file or directory" ]
					then
						echo "Accounts found:"
						ls *"$nam2"*
					else
						echo "No Accounts found"
						go=0
					fi
				done
			elif [ "$results" != "ls: cannot access *$name*: No such file or directory" ]
			then
				echo ""
				echo "Accounts found:"
				ls *"$nam1"*
			else
				echo ""
				echo "No Accounts found"
				go=0
			fi
		done
	if [ -f "$name" ]
	then
		echo "Account Successfully Created."
	fi
	cd "$d"
	elif [ "$opt" = 99 ]
	then
		clear
		echo "LARRY'S ARCADE MANAGEMENT SYSTEM (LAMS) Version $VERSION"
		echo ""
		echo "Developed by HaneyComputerSystems"      # A fictional company
		echo "Lead Developer: Jonah D. Haney"
		echo ""
		echo "Contact Information:"
		echo "  E-Mail: jdhaney97@gmail.com"
	elif [ "$opt" = 0 ]
	then
		sudo shutdown -P 0                            # Hopefully the script was run by sudo
	else
		echo "option $opt not recognized"
	fi
if [ "$opt" != 0 ]
then
	echo ""
	read -sp "Press <Enter> To Continue..." null
fi
done
