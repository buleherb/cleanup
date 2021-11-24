#!/usr/bin/env bash

# Set shell options
set -eou pipefail
#set -x    # for debugging purposes - this prints the command that is to be executed before the command is executed

USAGE_func() {
    echo "usage"
}

TMP_FILE_REMOVED_SUCCESSFULLY=""
SUPPRESS=""
VERBOSE=""
while getopts "d:xvshf:" opt; do
    case "$opt" in
        d) DIRECTORIES+=("$OPTARG");;
        f) FILETYPES+=("$OPTARG");;
        x) set -x;;
        v) VERBOSE="1";;
        s) SUPPRESS="1";;
        h) USAGE_func;;
        *) USAGE_func;;
    esac
done
shift $((OPTIND -1))

REMOVE_TMP_func() {
    if [[ -n $(printf "$TMP_FILE_REMOVED_SUCCESSFULLY" | grep -w "$TMP_FILE") ]]; then
        :
    else
        if [[ -a "$TMP_FILE" ]]; then
            rm -r "$TMP_FILE"
            if [[ -a "$TMP_FILE" ]]; then
                if [[ -n "$SUPPRESS" ]]; then
                    :
                else
                    echo "CLEAENUP ERROR: File "$TMP_FILE" could not be removed/still somehow exists after removal."
                fi
                exit 5
            else
                if [[ -n "$VERBOSE" ]]; then
                    echo "CLEAENUP INFO: File "$TMP_FILE" removed successfully."
                else
                    :
                fi
                TMP_FILE_REMOVED_SUCCESSFULLY+=" "$TMP_FILE""
            fi
        else
            if [[ -n "$VERBOSE" ]]; then
                echo "CLEAENUP INFO: File "$TMP_FILE" doesn't exist."
            else
                :
            fi
        fi
    fi
}

if [[ -n "${DIRECTORIES[@]}" ]]; then
    for DIRECTORY in "${DIRECTORIES[@]}"; do
        for TMP in "$@"; do
            TMP_FILE="$DIRECTORY"/"$TMP"
            REMOVE_TMP_func
        done
        for FILETYPE in ${FILETYPES[@]}; do
            if [[ -n $(find "$DIRECTORY" -name "*"$FILETYPE"" -type f) ]]; then
                for TMP_FILE in $(find "$DIRECTORY" -name "*"$FILETYPE"" -type f); do
                    REMOVE_TMP_func
                done
            else
                if [[ -n "$VERBOSE" ]]; then
                    echo "CLEAENUP INFO: Couldn't find any '"$FILETYPE"' filetype within directory "$DIRECTORY"."
                else
                    :
                fi
            fi
        done
    done
else
    :
fi

for TMP_FILE in "$@"; do
    REMOVE_TMP_func
done

exit 0