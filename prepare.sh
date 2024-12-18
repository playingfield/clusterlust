#!/bin/bash
ansible-galaxy install -r roles/requirements.yml
ansible-galaxy collection install -r collections/requirements.yml
