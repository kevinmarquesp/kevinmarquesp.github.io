#!/usr/bin/env bash

#blog.sh: blog.sh - v2.1.0
#blog.sh:
#blog.sh: This script is just a "simple" helper that allows me to setup my blog
#blog.sh: repository in new machines quickly, add more themes and sutuff like
#blog.sh: like that (everything that can be automated, shal be automated).
#blog.sh:
#blog.sh: Also, this script is useful when I want to create new blog posts or
#blog.sh: new essays, tweets, or anything that I found cool to put on this
#blog.sh: web site. Just make things a little more easier to change...
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
        "s" | "setup") echo "setup ${@}"; break ;;
    esac
done