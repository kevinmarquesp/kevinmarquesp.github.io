#!/usr/bin/env bash

#setup: setup - v0.2.0
#setup:
#setup: After you've clonned this repo, run this script to clone all the themes
#setup: submodules and start the server. It's used to see if everything is
#setup: working just fine.
#setup:
#setup: Arguments:
#setup:     -h --help   Show this help message.

function setup {
    FUNCNAME="setup"
    ARGS=$(getopt --name ${FUNCNAME}\
                --options "h"\
                --longoptions "help"\
                -- "${@}")

    [ $? -ne 0 ] && exit $?
    eval "set -- ${ARGS}"
    unset ARGS

    while true
    do
        case "${1}" in
            "-h" | "--help")
                grep --color=never "^#${FUNCNAME}:" "${BASH_SOURCE}" |
                    sed "s/^#${FUNCNAME}: \?//"
                exit
            ;;
            "--") shift;  break ;;
        esac
    done

    git submodule update --init --recursive
    hugo server --noHTTPCache
}


#new: new - v0.1.0
#new:
#new: Creates a new publication on this website, usually a blog post. It will
#new: also format the title string to include only `[a-z0-9_-]` characters and
#new: will be concatenated with the current date and time.
#new:
#new: Arguments:
#new:   -h --help   Show this help message.
#new:   -d --dir    Directory that the publication folder will be created, default is "blog".
#new:   -e --eng    Use the english content directory instead of the portuguese (default) one.
#new:
#new: Examples:
#new:   $ new --eng "My First Impression About This New Language"
#new:   $ new --dir essays "Influência Das Inteligências Artificiais No Âmbito Educacional"
#new:   $ new --dir archived --eng "My First Blog Post Ever!"

function new {
    FUNCNAME="new"
    ARGS=$(getopt --name ${FUNCNAME}\
                --options "hd:e"\
                --longoptions "help,dir:,eng"\
                -- "${@}")

    [ $? -ne 0 ] && exit $?
    eval "set -- ${ARGS}"
    unset ARGS

    local dir="blog"
    local content="content"

    while true
    do
        case "${1}" in
            "-d" | "--dir")  content="${2}";        shift 2 ;;
            "-e" | "--eng")  content="content.en";  shift   ;;
            "-h" | "--help")
                grep --color=never "^#${FUNCNAME}:" "${BASH_SOURCE}" |
                    sed "s/^#${FUNCNAME}: \?//"
                exit
            ;;
            "--") shift;  break ;;
        esac
    done

    local TITLE="${@}"
    local PREFIX=$(date "+%y%m%d-%H%M")
    local NAME=$(iconv -t "ASCII//TRANSLIT" <<< "${TITLE}" |
        tr "[:punct:]" " " | sed 's/\(.*\)/\L\1/;s/ *$//;s/  */-/g')
    local TARGET="${content}/${dir}/${NAME}"

    hugo new "${TARGET}/index.md"

    mv "${TARGET}/index.md" "${TARGET}/index.md.tmp"
    sed "s/{% *[Tt][Ii][Tt][Ll][Ee] *%}}/${TITLE}/" "${TARGET}/index.md.tmp" > "${TARGET}/index.md"
    rm "${TARGET}/index.md.tmp"

    read -rn1 -p "Open file with ${EDITOR}? [Y/n] " r_user
    [ "${r_user}" != "n" ] && $EDITOR "${TARGET}/index.md"
}


#blog.sh: blog.sh - v2.2.0
#blog.sh:
#blog.sh: This script is just a "simple" helper that allows me to setup my blog
#blog.sh: repository in new machines quickly, add more themes and sutuff like
#blog.sh: like that (everything that can be automated, shal be automated).
#blog.sh:
#blog.sh: Also, this script is useful when I want to create new blog posts or
#blog.sh: new essays, tweets, or anything that I found cool to put on this
#blog.sh: web site. Just make things a little more easier to change...
#blog.sh:
#blog.sh: Dependencies:
#blog.sh:   git, hugo
#blog.sh:
#blog.sh: Arguments:
#blog.sh:   -h --help   Show this help message.
#blog.sh:
#blog.sh: Examples:
#blog.sh:   $ ./blog.sh -- setup --help
#blog.sh:   $ ./blog.sh -- new --eng "Writing Complex Script Apps With Bash"

ARGS=$(getopt --name $(basename $0)\
              --options "h"\
              --longoptions "help"\
              -- "${@}")

[ $? -ne 0 ] && exit $?
eval "set -- ${ARGS}"
unset ARGS

while true
do
    case "${1}" in
        "-h" | "--help")
            grep --color=never "^#$(basename $0):" "${BASH_SOURCE}" |
                sed "s/^#$(basename $0): \?//"
            exit
        ;;
        "--") shift;  break ;;
    esac
done

while true
do
    case "${1}" in
        "s" | "setup")  setup "${@}";  break ;;
        "n" | "new")    new "${@}";    break ;;
    esac
done