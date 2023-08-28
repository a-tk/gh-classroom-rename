#!/bin/bash

usage() {
    echo "Usage: $0 
    [-o <organization name>]"
}

#TODO extend to allow the search string to be configured
while getopts "o:h:" opt; do
  case $opt in
    o)
        organization=${OPTARG}
        ;;
    \?)
        usage
        exit 1
        ;;
    :)
        usage
        exit 1
        ;;
  esac
done

if [ -z "$organization" ]; then
    usage
    exit 1
fi

gh repo list $organization --limit 1000 | while read -r repo _; do
  gh repo clone "$repo" "$repo"
  sleep 5
done