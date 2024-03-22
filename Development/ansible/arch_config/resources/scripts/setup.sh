#!/usr/bin/sh

ansible-playbook -vvvv "{{ .chezmoi.sourceDir }}/Development/ansible/arch_config/setup.yml"
