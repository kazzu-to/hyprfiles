#!/usr/bin/env bash

if [ "$1" = "true" ]; then
    # set your dark GTK theme
    gsettings set org.gnome.desktop.interface gtk-theme "Graphite-Dark"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
    gsettings set org.gnome.desktop.interface gtk-theme "Graphite-Light"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
fi

