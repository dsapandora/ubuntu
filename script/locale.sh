#!/bin/bash
set -e

echo "==> Setting LANG locale value"

locale-gen C.UTF-8 || true
update-locale LANG=en_GB.UTF-8
/bin/bash -c 'echo "export LANG=C.UTF-8" >> /etc/skel/.bashrc'