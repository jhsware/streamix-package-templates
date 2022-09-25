#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TEMPLATE_URL="https://raw.githubusercontent.com/jhsware/streamix-package-templates/master/release"
TEMPLATE_NAME= # Assigned further down
FULLSCREEN_OVERLAY= # Assigned further down


if [ "$1" = "help" ]; then
  echo <<EOF
Usage: create.sh [command] [options]

Commands:

help -- show this message

graphics-overlay -- create a graphics overlay package

stinger-transition -- create a stinger transition package

Options:

--id -- (required) the unique id of your package i.e. my-amazing-graphics

--name -- (required) the name of the package as displayed in the app

--desc -- (required) a short description of what your graphics does (no newlines allowed)

--fullscreen -- create a fullscreen graphics overlay package

EOF
  exit 0
fi

declare -a REQUIRED_CMDS=(
  "curl"
  "tar"
  "sed"
  "npm"
)
# 0. Check that we have all available CLI apps for this script to work (tar, sed, npm)
for cmd in "${REQUIRED_CMDS[@]}"
do
  if hash $cmd 2>/dev/null; then
    printf ''
  else
    echo "${RED}ERROR!${NC} This script requires the command '$cmd'. It comes installed with macOS."
    exit 1
  fi
done


for i in "$@"; do
  case $i in
    --id=*)
    identifier="${i#*=}"
    shift
    ;;
    --name=*)
    name="${i#*=}"
    shift
    ;;
    --desc=*)
    desc="${i#*=}"
    shift
    ;;
    --fullscreen)
    fullscreen=true
    shift
    ;;
    *)
      if [[ "graphics-overlay stinger-transition" == *"${i}"* ]]; then
        CMD="${i}"
      fi
    ;;
  esac
done

# Check valid package name
if [[ "${identifier}" =~ [^a-z-] ]]; then
    echo "${RED}ERROR!${NC} Only lowercase letters a-z and dash (-) is allowed, try again!"
    exit 1
fi

echo "***************************"
echo "** Creating your package **"
echo "***************************"

##
## Graphics Overlay
##
if [ $CMD = "graphics-overlay" ]
then
  TEMPLATE_NAME="graphicsOverlayTemplate.tgz"
  if [ -z "$fullscreen" ]
  then
    FULLSCREEN_OVERLAY="true"
  fi
fi

##
## Stinger Transition
##
if [ $CMD = "stinger-transition" ]
then
  TEMPLATE_NAME="stingerTemplate.tgz"
fi

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
