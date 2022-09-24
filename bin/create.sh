#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TEMPLATE_URL="https://raw.githubusercontent.com/jhsware/streamix-package-templates/master/release"
TEMPLATE_NAME=
FULLSCREEN_OVERLAY=
REQUIRED_CMDS="curl tar sed npm"


echo "*******************************************"
echo "** Create your package (ctrl-c to abort) **"
echo "*******************************************"

# 0. Check that we have all available CLI apps for this script to work (tar, sed, npm)
for cmd in $REQUIRED_CMDS
do
  if hash $cmd 2>/dev/null; then
    printf ''
  else
    echo "${RED}ERROR!${NC} This script requires the command '$cmd'. It comes installed with macOS."
    exit 1
  fi
done

# Select package type
PS3='Please enter package type: '
options=("Graphics Overlay" "Fullscreen Graphics Overlay" "Stinger Transition" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Graphics Overlay")
            TEMPLATE_NAME="graphicsOverlayTemplate.tgz"
            break
            ;;
        "Fullscreen Graphics Overlay")
            TEMPLATE_NAME="graphicsOverlayTemplate.tgz"
            FULLSCREEN_OVERLAY="true"
            break
            ;;
        "Stinger Transition")
            TEMPLATE_NAME="stingerTemplate.tgz"
            break
            ;;
        "Cancel")
            exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

# 1. Ask for user settings (package name, app name, app description, type (stinger/graphics overlay))
read -p "Package identifier i.e. 'your-package-name': " identifier
# Check valid package name
if [[ "${identifier}" =~ [^a-z-] ]]; then
    echo "${RED}ERROR!${NC} Only lowercase letters a-z and dash (-) is allowed, try again!"
    exit 1
fi
read -p "Name in app i.e. 'My Package': " name
read -p "Description in app i.e. 'Description of effect.': " desc
echo

# 2. Download and unpack template .tgz
echo "Downloading template and creating project..."
curl -L  $TEMPLATE_URL/$TEMPLATE_NAME | tar xvz -C $identifier

# 3. Update config files
echo "Updating config files..."
pushd $identifier
sed -i "" "s/\[name-of-your-package\]/$identifier/g" package.json src/streamix_package.json src/Component.tsx src/component.scss
sed -i "" "s/\[name-in-app\]/$name/g" src/streamix_package.json
sed -i "" "s/\[description-in-app\]/$desc/g" src/streamix_package.json

if [ $FULLSCREEN_OVERLAY = "true" ]
then
  echo "Fullscreen"
  sed -i "" "s/\"fullscreen\": false/\"fullscreen\": true/g" src/streamix_package.json
fi
popd

echo "Install npm packages..."
(cd $identifier && npm i)

# 4. If Git exists, initialize repos and commit initial state
if hash git 2>/dev/null
then
  echo "Initialising as Git repository and committing files"
  (cd $identifier && git init && git add --all && git commit -m "initial commit")
fi

# 5. Instructions on how to proceed
echo
echo "${GREEN}DONE! Open the files in $identifier/src/ and start coding!${NC}"
echo
echo "Documentation can be found in $identifier/README.md."
echo "To start the development server, use 'npm run dev'."
echo "Code changes will update in browser automatically."
echo
