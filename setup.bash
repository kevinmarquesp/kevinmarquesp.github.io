#!/usr/bin/env bash

EDITOR="nvim"
COMMIT_MSG_FILE=".env/commit.txt"

OPTIONS="n:p"
LONGOPTIONS="new-article:,publish"
ARGS=$(getopt --options "$OPTIONS" --longoptions "$LONGOPTIONS" --name "$0" -- "$@")

[ $? -ne 0 ] && exit 1
eval set -- "$ARGS"
unset OPTIONS LONGOPTIONS ARGS

function new_article {
    ARTICLE_NAME="$1"

    CURRENT_DATE=$(date "+%y%m%d%H%M%S")
    DIRECTORY_NAME="${CURRENT_DATE}_$(
        iconv -t ASCII//TRANSLIT <<< "$ARTICLE_NAME" | # convert the non ASCII characters
        tr "[:upper:]" "[:lower:]" |                   # convert all to lower case
        tr "[:punct:]" " " |                           # replace all ponctuations to spaces
        tr " " "-" |                                   # replace all spaces to dashes
        tr -s "-" "-"                                  # remove the repeating dash sequences
    )"
    unset CURRENT_DATE

    ARTICLE="content/post/$DIRECTORY_NAME/index.md"
    hugo new "$ARTICLE"

    ARTICLE_HEADERS=$(sed -e "s/^title: \".*\"\$/title: \"$ARTICLE_NAME\"/g" < "$ARTICLE")
    echo "$ARTICLE_HEADERS" > "$ARTICLE"
    unset ARTICLE_HEADERS

    [ -e ".env" ] || mkdir ".env"
    echo "$ARTICLE_NAME" > "$COMMIT_MSG_FILE"

    read -n1 -r -p ':: Open the generated file? [Y/n] ' USER
    [ "$USER" != 'n' ] &&
        $EDITOR "$ARTICLE"
}

function publish {
    COMMIT_MSG=$(cat "$COMMIT_MSG_FILE" |
        tr "[:upper:]" "[:lower:]" |
        tr "[:punct:]" " " |
        tr -s " " " ")

    git add content/
    git commit -m "post: $COMMIT_MSG"
    git push
}

case $1 in
    '-n'|'--new-article') new_article "$2"; exit ;;
    '-p'|'--publish') publish; exit ;;
    *) exit 1 ;;
esac
