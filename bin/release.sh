#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

BASEDIR=$(dirname "$0")
IFS_DEFAULT=$IFS

if [ $BASEDIR != "." ]
then
    echo "You should run the npm script: 'npm run release'"
    exit 1
fi

echo "*********************************"
echo "** Create release of templates **"
echo "*********************************"

declare -a TEMPLATES=(
    "graphics-template graphicsOverlayTemplate.tgz"
    "stinger-template stingerTemplate.tgz"
)

for val in "${TEMPLATES[@]}"; do
    tmp=($val)
    src=${tmp[0]}
    dest=${tmp[1]}
    # echo "- $src $dest"
    echo "${GREEN}$src:${NC} Releasing template as release/$dest"
    cp docs/*.md templates/$src
    (cd templates/$src && tar -cvzf ../../release/$dest ./)
    rm templates/$src/*.md
done

echo "${GREEN}DONE!${NC}"
echo "To complete the release commit and push to master."
