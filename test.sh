#/bin/bash
GREEN='\033[0;32m'
RESET='\033[0m'
read a
i=0
while [ $i -lt $a ]; do 
	  echo -e "${GREEN}$i${RESET}"
	((i++))
done