#!/usr/bin/env bash
##-*-coding: utf-8; mode: shell-script;-*-##

EMACS_HOME="$HOME/.jumbo"
ENCODING='zh_CN.UTF-8'

export LC_CTYPE="$ENCODING"
export LC_ALL="$ENCODING"
export LANG="$ENCODING"
export TERM='xterm-256color'

exec -a ec -- "$EMACS_HOME/bin/emacsclient" -a "" -t "$@"
