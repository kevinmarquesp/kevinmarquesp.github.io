#!/usr/bin/env bash

#EDITOR="nvim"
EDITOR="code"
THEME_REPO_DIRECTORY="themes/hugo-bearcub"

which git > /dev/null || echo "${0} :: git is not installed"

install_theme() {
    read -p "${0} :: <read> Enter the git repo link: " r_gitrepo

    git submodule add --depth=1 "${r_gitrepo}" "${THEME_REPO_DIRECTORY}"
    git submodule update --init --recursive

}

update_theme() {
    if [ ! -e "${THEME_REPO_DIRECTORY}" ]; then
        echo "${0} :: theme ${THEME_REPO_DIRECTORY} file doesn't exist"

        read -n1 -r -p "${0} :: <read> Install theme? [Y/n] " r_user
        [ "${r_user}" != 'n' ] &&
            install_theme

        exit
    fi

    cd "${THEME_REPO_DIRECTORY}"
    git submodule update --remote --merge
}

new_article() {
    if [ "${1}" = "-e" ] || [ "${1}" = "--eng" ]
    then
        CONTENT="content.en"
        TARGET_DIR="${2}"
        ARTICLE_NAME="${3}"
    else
        CONTENT="content"
        TARGET_DIR="${1}"
        ARTICLE_NAME="${2}"
    fi

    DIRECTORY_PREFIX="$(date '+%y%m%d-%H%M')"
    DIRECTORY_SUFIX="$(iconv -t ASCII//TRANSLIT <<< "${ARTICLE_NAME}" |
        tr "[:punct:]" " " | sed -e 's/\(.*\)/\L\1/;s/ *$//;s/  */-/g')"

    DIRECOTRY_NAME="${DIRECTORY_PREFIX}_${DIRECTORY_SUFIX}"
    ARTICLE_FILE="${CONTENT}/${TARGET_DIR}/${DIRECOTRY_NAME}/index.md"

    hugo new "${ARTICLE_FILE}"

    # for some reason, the sed command alone makes the target file blank...
    mv "${ARTICLE_FILE}" "${ARTICLE_FILE}.tmp"
    sed -e "s/{% *[Tt]itle *%}/${ARTICLE_NAME}/" "${ARTICLE_FILE}.tmp" > "${ARTICLE_FILE}"
    rm "${ARTICLE_FILE}.tmp"

    read -n1 -r -p "${0} :: <read> Open generated file? [Y/n] " r_user
    [ "${r_user}" != 'n' ] &&
        ${EDITOR} "${ARTICLE_FILE}"
}

case "${1}" in
    "install-theme"|"install") install_theme; exit ;;
    "update-theme"|"update") update_theme; exit ;;
    "new-article"|"new") new_article "${2}" "${3}" "${4}"; exit ;;
esac
