#!/usr/bin/env bash
##-*-coding: utf-8; mode: shell-script;-*-##
set -e


cd
exec -l -a emacs -- "$HOME/Applications/Emacs.app/Contents/MacOS/Emacs" "$@"
exit 1
