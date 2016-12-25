#!/bin/bash

# Links all dotfiles from ./config to ~.
# -Christopher Welborn 12-25-2016
appname="Make Config Links"
appversion="0.0.1"
apppath="$(readlink -f "${BASH_SOURCE[0]}")"
appscript="${apppath##*/}"
# appdir="${apppath%/*}"

shopt -s dotglob
shopt -s nullglob

function echo_err {
    # Echo to stderr.
    echo -e "$@" 1>&2
}

function fail {
    # Print a message to stderr and exit with an error status code.
    echo_err "$@"
    exit 1
}

function fail_usage {
    # Print a usage failure message, and exit with an error status code.
    print_usage "$@"
    exit 1
}

function print_usage {
    # Show usage reason if first arg is available.
    [[ -n "$1" ]] && echo_err "\n$1\n"

    echo "$appname v. $appversion

    Usage:
        $appscript -h | -v
        $appscript [-d] [FILE...]

    Options:
        FILE          : File to make a symlink for in ~.
        -d,--dryrun   : Dry run, just show what would be done.
        -h,--help     : Show this message.
        -v,--version  : Show $appname version and exit.
    "
}

declare -a userargs
do_dryrun=0

for arg; do
    case "$arg" in
        "-d" | "--dryrun")
            do_dryrun=1
            ;;
        "-h" | "--help")
            print_usage ""
            exit 0
            ;;
        "-v" | "--version")
            echo -e "$appname v. $appversion\n"
            exit 0
            ;;
        -*)
            fail_usage "Unknown flag argument: $arg"
            ;;
        *)
            userargs+=("$arg")
    esac
done

((${#userargs[@]} == 0)) && userargs=(.*)

let errs=0
ignore_pat='(^\.$)|(^\.\.$)|(^\.git$)|(^\.gitmodules$)'
for filepath in "${userargs[@]}"; do
    filename="${filepath##*/}"

    filepath="$(readlink -f "$filepath")"
    destpath="${HOME}/${filename}"
    [[ "$filename" =~ $ignore_pat ]] && {
        echo_err "Ignoring file: $filepath"
        continue
    }
    [[ -e "$destpath" ]] && {
        echo_err "Already exists: $destpath"
        continue
    }
    ((do_dryrun)) && {
        echo_err "Would've ran: ln -s $filepath $destpath"
        continue
    }
    if ln -s "$filepath" "$destpath"; then
        printf "Linked: %s -. %s\n" "$filepath" "$destpath"
    else
        echo_err "Failed to create symlink: $destpath"
        let errs+=1
    fi
done

exit $errs
