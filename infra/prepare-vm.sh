#!/usr/bin/env bash
set -euo pipefail

DEPLOY_USER="${1:-$USER}"

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$DEPLOY_USER"

echo "Docker is ready for $DEPLOY_USER. Sign out and sign in again before running docker without sudo."
