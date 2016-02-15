#!/usr/bin/env bash
##-*-coding: utf-8; mode: shell-script;-*-##
set -e


EMACS_HOME="$HOME/Applications/Emacs.app/Contents/MacOS"

ENCODING='zh_CN.UTF-8'

export LC_CTYPE="$ENCODING"
export LC_ALL="$ENCODING"
export LANG="$ENCODING"
export TERM='xterm-256color'

cd
exec -l -a ec -- "$EMACS_HOME/bin/emacsclient" -t -a "" "$@"
exit 1
