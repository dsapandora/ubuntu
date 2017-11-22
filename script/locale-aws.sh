#!/bin/bash

echo "==> Generating en_GB locale"
locale-gen "en_GB.UTF-8"

echo "==> Setting LANG locale value"
update-locale LANG=en_GB.UTF-8
