#!/bin/sh

function link_if_exists() {
    source="$1"
    destination="$2"

    # TODO: Add validation for parameters
    if [ -L "$destination" ]; then
        echo "Symlink from $source to $destination exists already. Continuing..."
        return
    fi

    ln -sv $source $destination
}

export -f link_if_exists
