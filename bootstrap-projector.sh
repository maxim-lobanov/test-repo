#!/bin/bash

set -euo pipefail

# Setup miniconda as a version of Python >3.6 for Projector
curl -s -L -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x ./Miniconda3-latest-Linux-x86_64.sh
sudo ./Miniconda3-latest-Linux-x86_64.sh -b -p /var/opt/miniconda
rm ./Miniconda3-latest-Linux-x86_64.sh

# dump the version
/var/opt/miniconda/bin/python3 --version
/var/opt/miniconda/bin/pip3 --version

# Install projector and add the installation location to the path
sudo runuser -l runner -c '
/var/opt/miniconda/bin/pip3 install projector-installer --user
echo '\''export PATH="$HOME/.local/bin:$PATH"'\'' >> ~/.profile
'

# Install Rider
# 1. Find the best version of Rider
#    Question prompts:
#    - Select only tested versions? y
#    Then, take the last line, get the text of the option (everything after the period), and trim whitespace
# 2. Install Rider
sudo runuser -l runner -c '
choice=$(printf '\''y\n'\'' | /home/runner/.local/bin/projector --accept-license find rider | tail -1 | cut -d . -f 2- | xargs)
/home/runner/.local/bin/projector autoinstall --config-name "RiderForActions" --ide-name "$choice" --port 10000
'
