#!/bin/bash
echo "==> Reducing systemd networking.service timeout"

mkdir -p /etc/systemd/system/networking.service.d

echo -e "[Service]\nTimeoutStartSec=10" >> /etc/systemd/system/networking.service.d/reduce-timeout.conf