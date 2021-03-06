#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

COMMENT=\#*

sudo -v

# Install Brewfile contents
brew bundle

find * -name "*.list" | while read fn; do
    cmd="${fn%.*}"
    # Check if the command starts with a number,
    # if so, remove the first two characters from the command
    # Supports up to ten priority lists
    if [[ "$cmd" =~ [0-9]+[[:space:]].* ]]; then
        cmd=${cmd:2:${#cmd}}
    fi
    while read package; do
        if [[ $package == $COMMENT ]];
        then continue
        fi
        if [[ $cmd == code* ]]; then
            echo "$cmd $package"
            $cmd $package
        else
            echo "$cmd install $package"
            $cmd install $package
        fi
    done < "$fn"
done
