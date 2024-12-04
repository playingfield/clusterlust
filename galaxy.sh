#!/bin/bash
ansible-galaxy install -p galaxy_roles -r roles/requirements.yml --force
ansible-galaxy collection install -r collections/requirements.yml
