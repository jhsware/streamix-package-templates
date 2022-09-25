#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -f create.sh ]
then
  rm create.sh
fi

curl -s https://raw.githubusercontent.com/jhsware/streamix-package-templates/master/bin/create.sh -o create.sh
chmod 755 create.sh
echo -e "${GREEN}DONE! Template package creator installed!${NC}"
echo "Run ./create.sh"
