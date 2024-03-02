#!/usr/bin/env bash

#help: help - v0.1.0
#help:
#help: Given a function name, this command will use `sed` and `grep` to filter
#help: the comments that documents the help message of the specified function.
#help: It was created to decrease code repetition because every function has a
#help: `-h` and a `--help` option available.
#help:
#help: Arguments:
#help:  -h --help   Show this help message.
#help:
#help: Paramters:
#help:  $1  Function name, will give an error if there is no help comments available.
#help:
#help: Examples:
#help:  $ help "blog.sh"
#help:  $ help "arg_parser"
#help:  $ help "new"

function help {
    [ "${1}" = "-h" ] || [ "${1}" = "--help" ] &&
        help "help"

    grep --color=never "^#${1}:" "${BASH_SOURCE}" |
        sed "s/^#${1}: \?//"
    exit
}

#arg_parser: arg_parser - v0.2.0
#arg_parser:
#arg_parser: Yet another `getopt` wrapper, this function will return a string
#arg_parser: `set -- [PARSED_ARGS]` where `[PARSED_ARGS]` will be the parsed
#arg_parser: arguments generated by the `getopt` command.
#arg_parser:
#arg_parser: As you can deduce, you'll need to run the output string of this
#arg_parser: function with `eval`, so the arguments can be applyed to your
#arg_parser: function or command.
#arg_parser:
#arg_parser: Arguments:
#arg_parser:    -h --help   Show this help message.
#arg_parser:
#arg_parser: Paramters:
#arg_parser:    $1  Name of the command/function, useful for debug.
#arg_parser:    $2  Short options.
#arg_parser:    $3  Long options
#arg_parser:    $@  Arguments array that will be parsed with `getopt`.
#arg_parser:
#arg_parser: Examples:
#arg_parser:    $ eval $(arg_parser "new" "hd:e" "help,dir:,eng" "--dir blog 'Olá, mundo!'")
#arg_parser:    $ eval $(arg_parser "${FUNC}" "h" "help" "${@}")

function arg_parser {
    [ "${1}" = "-h" ] || [ "${1}" = "--help" ] &&
        help "arg_parser"

    local FUNC="${1}"
    local OPTIONS="${2}"
    local LONG_OPTIONS="${3}"

    shift 3

    local ARGS=$(getopt --name ${FUNC}\
                --options "${OPTIONS}"\
                --longoptions "${LONG_OPTIONS}"\
                -- "${@}")

    if [ $? -ne 0 ]
    then
        printf "\nError: Argument parser error!\n\n"
        exit $?
    fi

    echo "set -- ${ARGS}"
}

#setup: setup - v0.4.0
#setup:
#setup: After you've clonned this repo, run this script to clone all the themes
#setup: submodules and start the server. It's used to see if everything is
#setup: working just fine.
#setup:
#setup: Arguments:
#setup:     -h --help   Show this help message.

function setup {
    local FUNC="setup"

    eval $(arg_parser "${FUNC}" "h" "help" "${@}")

    while true
    do
        case "${1}" in
            "-h" | "--help") help "${FUNC}" ;;
            "--") shift;  break ;;
        esac
    done

    git submodule update --init --recursive
    hugo server --noHTTPCache
}


#new: new - v1.4.0
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
    FUNC="new"
    eval $(arg_parser "${FUNC}" "hd:e" "help,dir:,eng" "${@}")

    local dir="blog"
    local content="content"

    while true
    do
        case "${1}" in
            "-d" | "--dir")  dir="${2}";            shift 2 ;;
            "-e" | "--eng")  content="content.en";  shift   ;;
            "-h" | "--help") help "${FUNC}" ;;
            "--") shift;  break ;;
        esac
    done

    local TITLE="${@}"

    [ -z "${TITLE}" ] && return 1

    local PREFIX=$(date "+%y%m%d-%H%M")
    local NAME=$(iconv -t "ASCII//TRANSLIT" <<< "${TITLE}" |
        tr "[:punct:]" " " | sed 's/\(.*\)/\L\1/;s/ *$//;s/  */-/g')
    local TARGET="${content}/${dir}/${PREFIX}_${NAME}"

    hugo new "${TARGET}/index.md"

    mv "${TARGET}/index.md" "${TARGET}/index.md.tmp"
    sed "s/{% *[Tt][Ii][Tt][Ll][Ee] *%}/${TITLE}/" "${TARGET}/index.md.tmp" > "${TARGET}/index.md"
    rm "${TARGET}/index.md.tmp"

    read -rn1 -p "Open file with ${EDITOR}? [Y/n] " r_user
    [ "${r_user}" != "n" ] && $EDITOR "${TARGET}/index.md"
}


#publish: publish - v0.3.0
#publish:
#publish: After writing an article, I'd like to just run a command to commit its
#publish: files and push them to Github, after that, the HUGO Github Action will
#publish: do the rest for me. But writing a commit message is just too tedius...
#publish:
#publish: Arguments:
#publish:   -h --help   Show this help message.
#publish:
#publish: Examples:
#publish:   $ publish -h
#publish:   $ publish

function publish {
    local FUNC="publish"
    eval $(arg_parser "${FUNC}" "h" "help" "$@")

    local dir="blog"
    local content="content"

    while true
    do
        case "${1}" in
            "-h" | "--help") help "${FUNC}" ;;
            "--") shift; break ;;
        esac
    done

    git status -sv --porcelain content* |
        sed 's/^\(.\+ content\.\?.*\/.*\/[0-9].*\/\).*$/\1/' |
        awk '{ print $2 }' |
        sort |
        uniq |
        xargs -I{} -- bash -c "[ ! -f \"{}index.md\" ] && exit
            [ -z \"\$(git status -sv --porcelain {})\" ] && exit
            TITLE=\$(sed '2!d; s/^title: \"\?//; s/\"\?\$//' {}index.md)
            git add {}
            git commit -m \":tada: article: \${TITLE}\""

    git push
}

#blog.sh: blog.sh - v3.3.0
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
#blog.sh: Commands:
#blog.sh:   s setup     Quick clone git submodules and start the HUGO server.
#blog.sh:   n new       Create a new article of any kind.
#blog.sh:   p publish   Push to Github every content(.en) file modified/created.
#blog.sh:
#blog.sh: Arguments:
#blog.sh:   -h --help   Show this help message.
#blog.sh:
#blog.sh: Examples:
#blog.sh:   $ ./blog.sh setup --help
#blog.sh:   $ ./blog.sh new --eng "Writing Complex Script Apps With Bash"

while true
do
    case "${1}" in
        "s" | "setup")    shift;  setup "${@}";    break ;;
        "n" | "new")      shift;  new "${@}";      break ;;
        "p" | "publish")  shift;  publish "${@}";  break ;;
        "-h" | "--help") help "blog.sh" ;;
        *)
            printf "\nError: The '%s' string doesn't match to any valid command!\n\n" "$1"
            exit 1
        ;;
    esac
done