#!/bin/bash

#sudo mount -t msdos -o ro /dev/disk0s1 ./tmp-efi
rsync -rav --delete --exclude ".empty" --exclude "._*"  /Volumes/EFI/EFI/* .
sudo diskutil unmount /dev/disk0s1
