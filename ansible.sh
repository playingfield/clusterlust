#!/bin/bash
# Just `source ./ansible.sh`
deactivate
rm -rf ~/py3
python3.12 -m venv ~/py3
# shellcheck source=/dev/null
source ~/py3/bin/activate
pip install --upgrade pip wheel
pip install -r requirements.txt
