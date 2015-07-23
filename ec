#!/usr/bin/env bash
##-*-coding: utf-8; mode: shell-script;-*-##
set -e


ENCODING='zh_CN.UTF-8'

export LC_CTYPE="$ENCODING"
export LC_ALL="$ENCODING"
export LANG="$ENCODING"
export TERM='xterm-256color'

exec -l -a ec -- "$HOME/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" -nc -a "" "$@"
