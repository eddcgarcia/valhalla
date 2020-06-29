#!/bin/bash

for fpr in $(gpg2 --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u); do
    echo -e "5\ny\n" |  gpg2 --command-fd 0 --expert --edit-key $fpr trust;
done