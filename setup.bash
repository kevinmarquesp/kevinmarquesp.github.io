#!/usr/bin/env bash

OPTIONS="n:"
LONGOPTIONS="new-article:"
ARGS=$(getopt --options "$OPTIONS" --longoptions "$LONGOPTIONS" --name "$0" -- "$@")

[ $? -ne 0 ] && exit 1
eval set -- "$ARGS"
unset OPTIONS LONGOPTIONS ARGS

function new_article {
    ARTICLE_NAME="$1"

    CURRENT_DATE=$(date "+%y%m%d%H%M%S")
    DIRECTORY_NAME="${CURRENT_DATE}_$(iconv -t ASCII//TRANSLIT <<< "$ARTICLE_NAME" |
        tr "[:upper:]" "[:lower:]" |
        tr " " "-")"
    unset CURRENT_DATE

    ARTICLE="content/post/$DIRECTORY_NAME/index.md"
    hugo new "$ARTICLE"

    ARTICLE_HEADERS=$(sed -e "s/^title: \".*\"\$/title: \"$ARTICLE_NAME\"/g" < "$ARTICLE")
    echo "$ARTICLE_HEADERS" > "$ARTICLE"
    unset ARTICLE_HEADERS

    read -n1 -r -p ':: Open the generated file? [Y/n] ' USER
    [ "$USER" != 'n' ] &&
        $EDITOR "$ARTICLE"
}

case $1 in
    '-n'|'--new-article') new_article "$2"; exit ;;
    *) exit 1 ;;
esac
