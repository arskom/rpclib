#!/bin/bash

if [ -z "$1" ]; then
    echo Usage: $0 SPYNE_PACKAGE_PATH;
    echo "      for example:" $0 ../spyne/spyne

    exit 1;
fi

SPYNE_PATH="$1";

find "${SPYNE_PATH}" -type d | cut -d/ -f4- | xargs -n1 -i mkdir -p rpclib/{}
find "${SPYNE_PATH}" -type f -name "*.py" | grep -v test/ | cut -d/ -f4- | xargs -n1 -i touch rpclib/{}

for i in $(find rpclib -name "*.py" | cut -d. -f1 | grep -v __init__ | replace . "" | replace / . | cut -d "." -f2-); do
    echo "from spyne.$i import *" > rpclib/$(echo $i | replace . /).py;
done;

for i in $(find rpclib -name "*.py" | cut -d. -f1 | grep __init__ | replace . "" | replace / . | sed s/\\.__init__//g | cut -d "." -f2-); do
    echo "from spyne.$i import *" 2> /dev/null > rpclib/$(echo $i | replace . /)/__init__.py;
done;

echo "from spyne import *" > rpclib/__init__.py
