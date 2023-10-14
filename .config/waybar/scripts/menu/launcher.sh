#!/usr/bin/env bash

## Author : Amstel
## Github : Amstel-DEV
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)

dir="$HOME/.config/waybar/scripts/menu"
theme='style-sg'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
