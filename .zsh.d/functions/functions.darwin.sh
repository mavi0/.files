#!/usr/bin/env zsh

cdf() {
    if [ "$1" = "-h" ]; then
        echo "Usage: cdf"
        echo "Open the directory of the most recently viewed Finder window in the CLI"
        return 0
    fi
    if ! assert_commad "osascript"; then return 1; fi
    currFolderPath=$( osascript <<EOT
        tell application "Finder"
            try
        set currFolder to (folder of the front window as alias)
            on error
        set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
EOT
    )
    print_success "Setting working directory to ${currFolderPath}"
    if ! cd "${currFolderPath}"; then
        print_error "failed to set working directory"
        return 1
    fi
}

f() {
    if [ "$1" = "-h" ]; then
        echo "Usage: f [target-directory (optional)]"
        echo
        echo "Open the given path in finder"
        return 0
    fi
    if test -d "${1:-$(pwd)}"; then
        target="${1:-$(pwd)}"
    elif test -f "${1:-$(pwd)}"; then
        target="$(dirname "${1:-$(pwd)}")"
    else
        print_error "directory does not exist: $target"
        return 1
    fi
    if open -a "Finder" "$target"; then
        print_success "Opened directory in finder: $target"
    else
        print_error "Failed to open directory in finder: $target"
    fi
}

sexyman() {
    if [ "$1" = "-h" ]; then
        echo "Usage: sexyman '[command]'"
        echo "Show the man page of a command in a PDF using Preview"
        return 0
    fi
    if ! assert_commad "man"; then return 1; fi
    man -t "$@" | open -f -a "Preview"
}

parallels_ip() {
    if [ "$1" = "-h" ]; then
        echo "Usage: parallels_ip '[vm name]'"
        echo "Get the IP address of a running parallels VM by name"
        return 0
    fi
    if ! assert_commad "prlctl"; then return 1; fi
    if ! assert_commad "jq"; then return 1; fi
    if ip=$(prlctl list -f -j | jq -r -e --arg n "$1" '. | map(select(.name == $n))[0].ip_configured'); then
        echo "$ip"
        return 0
    else
        print_error "failed to get machine ip"
        return 1
    fi  
}

