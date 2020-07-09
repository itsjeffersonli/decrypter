#!/bin/bash

#check dependencies with root access
echo -e "\e[5mDate Logging"
echo  "Last Login = " $(date) >> log.txt
sleep 3

if [ "$(id -u)" != "0" ] > /dev/null 2>&1; then
    echo -e '\e[0;31m【!!】 This script need root permission\e[0m' 1>&2
    exit
fi

# check hash cat
which hashcat > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
	hashcat='1'
else
	hashcat='0'
fi

#check john
which john > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
	john='1'
else
	john='0'
fi
#checking depenencies (hashcat and john)
echo -n Check script dependencies = =;

sleep 3 & while [ "$(ps a | awk '{print $1}' | grep $!)" ] ; do for X in '-' '\' '|' '/'; do echo -en "\b$X"; sleep 0.1; done; done
if [ "$john" == "1" ] && [ "$hashcat" == "1" ]
	 then
		echo -en "\b【\e[1;33mPass\e[0m】"
		echo ""
		echo ""
		echo -e 'john         【\e[1;33mOk\e[0m】'
   		echo -e 'hashcat      【\e[1;33mOk\e[0m】'
		echo ""
		sleep 2
fi

if [ "$john" == "0" ] && [ "$hashcat" == "0" ]
	then
		fail='1'
		echo -en "\b \e[0;31m【Fail】\e[0m"
		echo ""
		echo ""
fi
#check hashcat dependencies
if [ "$hashcat" == "0" ]
	then
		echo -e "\e[91mLhashcat \e[0;31m【!!】 Not Found, please install it first\e[0m"
		read -p "do you want to install hashcat(Y or N): " hashcatoption
			if [ $hashcatoption == "Y" ] || [ $hashcatoption == "y" ]
				then
					sudo apt-get update
					sudo apt install hashcat -y
					read -p "Do you want to restart the shell?(Y or N): " restarting
						if [ $restarting == "Y" ] || [ $restarting == "y" ]
							then
								#sudo bash decrypter.sh
								$(sudo bash decrypter.sh)
						else
								exit
						fi
			fi
			if [ $hashcatoption == "N" ] || [ $hashcatoption == "n" ]
				then
					exit
			fi
fi
#check john dependencies
if [ "$john" == "0" ]
	then
                echo -e "\e[91mLhashcat \e[0;31m【!!】 Not Found, please install it first\e[0m"
		read -p "do you want to install john?(Y or N): " johnoption
			if [ $johnoption == "Y" ] || [ $johnoption == "y" ]
				then
					sudo apt-get update
					sudo apt install john -y
					read -p "Do You Want to restart the shell?(Y or N): " restarting
						if [ $restarting == "Y" ] || [ $restarting == "y" ]
							then
								#sudo bash decrypter.sh
								$(sudo bash decrypter.sh)
						else
								exit
						fi
			fi
			if [ $johnoption == "N" ] || [ $johnoption == "n" ]
				then
					exit
			fi
fi

if [ "$fail" == "1" ]
	then
    		echo ""
             	echo -e '\e[0;31mExiting....\e[0m'
    		exit
fi
#codes for the program

read -p "[1]92mhashcat
[2]john
[!]Choose The tool you want to use[!]:	" option

if [ $option == 1 ]
	then
		read -p "Do you want to see the hashes types(Y or N): " bool
			if [ $bool == "Y" ] || [ $bool == "y" ]
				then
					cat  'hash modes'
					read -p "Do You Want to Restart The Shell?(Y or N): " restartshell
						if  [ $restartshell == "Y" ] || [ $restartshell == "y" ]
							then
								$(sudo bash decrypter.sh)
						else
							exit
						fi
			fi
            		if [ $bool == "N" ] || [ $bool == "n" ]
                		then
    			    		read -p "input the hash type(number only): " hashtype
    					read -p "wordlist(just the file name):" wordlists
    				        	dir1=$(locate $wordlists)
    					read -p "Input your file you want to crack: " filehash
    						dir2=$(locate $filehash)
    					hashcat -m $hashtype  $dir2  $dir1
            fi
fi

if [ $option == 2 ]
	then
                read -p "wordlist(just the file name):" wordlists
                        dir1=$(locate $wordlists)
                read -p "Input your file you want to crack: " filehash
                        dir2=$(locate $filehash)
                john --wordlist=$dir1 $dir2
fi
