#!/usr/bin/env zsh

## Notes
## -----
## - Make no assumptions about aliases (these are sourced **after** functions in the rc file)
## - All logic for a function should be in just 1 function 

# CDHOOK_GIT_REPO=
# cd() {
#     builtin cd "$@" || exit 1

#     if git rev-parse > /dev/null 2>&1; then
#         if [ "$CDHOOK_GIT_REPO" != "$(basename "$(git rev-parse --show-toplevel)")" ]; then
#             onefetch
#             CDHOOK_GIT_REPO=$(basename "$(git rev-parse --show-toplevel)")
#         fi
#     fi
# }

# open visual studio code on a remote target
vscssh() {
    if [ "$1" = "-h" ] || [[ ! $# -eq 2 ]]; then
        echo "Usage: code-ssh [ssh target] [target directory]"
        echo "Open VSCode connected to a remote file/dir via SSH"
        return 0
    fi
    if ! assert_commad "code"; then return 1; fi
    if [ "$#" -eq 1 ]; then
        code --new-window --remote ssh-remote+"${1}"
    elif [ "$#" -eq 2 ]; then
        code --new-window --remote ssh-remote+"${1}" "${2}"
    else
        print_error "usage: vscssh <ssh-host> <opt-host-dir>"
        return 1
    fi
}

transfer()
{
    local file
    declare -a file_array
    file_array=("${@}")

    if [[ "${file_array[@]}" == "" || "${1}" == "--help" || "${1}" == "-h" ]]
    then
        echo "${0} - Upload arbitrary files to \"transfer.sh\"."
        echo ""
        echo "Usage: ${0} [options] [<file>]..."
        echo ""
        echo "OPTIONS:"
        echo "  -h, --help"
        echo "      show this message"
        echo ""
        echo "EXAMPLES:"
        echo "  Upload a single file from the current working directory:"
        echo "      ${0} \"image.img\""
        echo ""
        echo "  Upload multiple files from the current working directory:"
        echo "      ${0} \"image.img\" \"image2.img\""
        echo ""
        echo "  Upload a file from a different directory:"
        echo "      ${0} \"/tmp/some_file\""
        echo ""
        echo "  Upload all files from the current working directory. Be aware of the webserver's rate limiting!:"
        echo "      ${0} *"
        echo ""
        echo "  Upload a single file from the current working directory and filter out the delete token and download link:"
        echo "      ${0} \"image.img\" | awk --field-separator=\": \" '/Delete token:/ { print \$2 } /Download link:/ { print \$2 }'"
        echo ""
        echo "  Show help text from \"transfer.sh\":"
        echo "      curl --request GET \"https://transfer.sh\""
        return 0
    else
        for file in "${file_array[@]}"
        do
            if [[ ! -f "${file}" ]]
            then
                echo -e "\e[01;31m'${file}' could not be found or is not a file.\e[0m" >&2
                return 1
            fi
        done
        unset file
    fi

    local upload_files
    local curl_output
    local awk_output

    du -c -k -L "${file_array[@]}" >&2
    # be compatible with "bash"
    if [[ "${ZSH_NAME}" == "zsh" ]]
    then
        read $'upload_files?\e[01;31mDo you really want to upload the above files ('"${#file_array[@]}"$') to "transfer.sh"? (Y/n): \e[0m'
    elif [[ "${BASH}" == *"bash"* ]]
    then
        read -p $'\e[01;31mDo you really want to upload the above files ('"${#file_array[@]}"$') to "transfer.sh"? (Y/n): \e[0m' upload_files
    fi

    case "${upload_files:-y}" in
        "y"|"Y")
            # for the sake of the progress bar, execute "curl" for each file.
            # the parameters "--include" and "--form" will suppress the progress bar.
            for file in "${file_array[@]}"
            do
                # show delete link and filter out the delete token from the response header after upload.
                # it is important to save "curl's" "stdout" via a subshell to a variable or redirect it to another command,
                # which just redirects to "stdout" in order to have a sane output afterwards.
                # the progress bar is redirected to "stderr" and is only displayed,
                # if "stdout" is redirected to something; e.g. ">/dev/null", "tee /dev/null" or "| <some_command>".
                # the response header is redirected to "stdout", so redirecting "stdout" to "/dev/null" does not make any sense.
                # redirecting "curl's" "stderr" to "stdout" ("2>&1") will suppress the progress bar.
                curl_output=$(curl --request PUT --progress-bar --dump-header - --upload-file "${file}" "https://transfer.sh/")
                awk_output=$(awk \
                    'gsub("\r", "", $0) && tolower($1) ~ /x-url-delete/ \
                    {
                        delete_link=$2;
                        print "Delete command: curl --request DELETE " "\""delete_link"\"";

                        gsub(".*/", "", delete_link);
                        delete_token=delete_link;
                        print "Delete token: " delete_token;
                    }

                    END{
                        print "Download link: " $0;
                    }' <<< "${curl_output}")

                # return the results via "stdout", "awk" does not do this for some reason.
                echo -e "${awk_output}\n"

                # avoid rate limiting as much as possible; nginx: too many requests.
                if (( ${#file_array[@]} > 4 ))
                then
                    sleep 5
                fi
            done
            ;;

        "n"|"N")
            return 1
            ;;

        *)
            echo -e "\e[01;31mWrong input: '${upload_files}'.\e[0m" >&2
            return 1
    esac
}

print_success() {
    printf "\033[0;32m%s\033[0m\n" "${1}"
}

print_warn() {
    printf "\033[0;33m%s\033[0m\n" "${1}"
}

print_error() {
    printf "\033[0;31m%s\033[0m\n" "${1}"
}


assert_commad() {
    if ! command -v "${1}" > /dev/null 2>&1; then
        if [ "${2}" != "-q" ]; then
            print_error "tool ${1} is required"
        fi
        return 1
    fi
    return 0
}

run_alternative() {
    if [ "${1}" = "-h" ]; then
        echo "Usage: run_alternative '[original command]' '[desired alternative]' '[web link for alternative]' ...flags for the command (will be applied to either)"
        echo "Attempt to run an alternative command if available, if not run the orignal."
        return 0
    fi
    if [ "$#" -lt 3 ]; then
        print_error "offer alternative requires 3+ arguments..."
        return 1
    fi
    if assert_commad "${2}" "-q"; then
        "${2}" "${@:4}"
    else
        print_warn "Consider installing '${2}': ${3}"
        "${1}" "${@:4}"
    fi
}
