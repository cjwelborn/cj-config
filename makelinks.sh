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

function confirm {
    # Confirm a user's answer to a yes/no quesion.
    [[ -n "$1" ]] && echo -e "\n$1"
    read -r -p $'\n'"$1 (y/N): " ans
    yespat='^[Yy]([Ee][Ss])?$'
    [[ "$ans" =~ $yespat ]] || return 1
    return 0
}

function echo_err {
    # Echo to stderr.
    echo -e "$@" 1>&2
}

function echo_file_op {
    # echo_err, with some formatting for "File Op: <filepath>"
    printf "%20s: %s\n" "$1" "$2"
}

function echo_file_op_err {
    # Same as echo_file_op 1>&2.
    echo_file_op "$@" 1>&2
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

# No args means use all of the dot files.
((${#userargs[@]} == 0)) && userargs=(.*)
[[ -d sublime-text ]] && userargs+=(sublime-text/*)

let errs=0
ignore_pat='(^\.$)|(^\.\.$)|(^\.git$)|(^\.gitmodules$)'
for filepath in "${userargs[@]}"; do
    filename="${filepath##*/}"
    filepath="$(readlink -f "$filepath")"
    destpath="${HOME}/${filename}"
    [[ "$filepath" =~ sublime-text/ ]] && destpath="$HOME/.config/sublime-text-3/Packages/User/$filename"
    [[ "$filename" =~ $ignore_pat ]] && {
        echo_file_op_err "Ignoring file" "$filepath"
        continue
    }
    [[ -e "$destpath" ]] && {
        echo_file_op_err "Already exists" "$destpath"
        continue
    }
    destdir="${destpath%/*}"
    [[ -d "$destdir" ]] || {
        echo_err "Destination directory does not exist: $destdir"
        confirm "Create the directory?" || continue
        if ((do_dryrun)); then
            echo_file_op_err "Would've ran" "mkdir -p $destdir"
        else
            mkdir -p "$destdir" || {
                echo_err "Failed to create destination directory: $destdir"
                continue
            }
        fi
    }
    ((do_dryrun)) && {
        echo_file_op_err "Would've ran" "ln -s $filepath $destpath"
        continue
    }
    if ln -s "$filepath" "$destpath"; then
        echo_file_op "Linked" "$filepath -> $destpath"
    else
        echo_err "Failed to create symlink: $destpath"
        let errs+=1
    fi
done

exit $errs
