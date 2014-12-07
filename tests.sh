#!/bin/bash

# Tests for Repman
# Copyright (C) 2014 Renato Silva
# Licensed under GPLv2 or later

repman="$1"
if [[ -z "$repman" ]]; then
    echo "Usage: $(basename "$0") PATH_TO_REPMAN"
    exit 1
fi

config="/etc/pacman.d/repman.conf"
if [[ -e $config ]]; then
    mv $config $config.bak
    trap "mv $config.bak $config" EXIT
fi
if [[ -t 1 ]]; then
    green_color="\e[0;32m"
    normal_color="\e[0m"
fi

tests=(repman::
         grep::"repman /etc/pacman.conf"
       repman::"list"
         grep::"repman /etc/pacman.conf"
       repman::"add renatosilva http://renatosilva.me/msys2"
       repman::"list"
       pacman::"--sync --list renatosilva"
       repman::"remove renatosilva"
       repman::"list"
       repman::"add"
       repman::"add renatosilva"
       repman::"remove renatosilva"
       repman::"list extra arguments"
       repman::"hello")

for test in "${tests[@]}"; do
    command="${test%%::*}"
    arguments="${test#*::}"
    [[ "$command" = repman ]] && command="$repman"
    echo -e "${green_color}\$ ${command} ${arguments}${normal_color}"
    $command $arguments
    echo
done
