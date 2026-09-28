#!/usr/bin/env bash
set -euo pipefail

: "${PROJECT_ID:?Set PROJECT_ID before running this script}"

VM_NAME="${VM_NAME:-tni-cicd-vm}"
ZONE="${ZONE:-asia-southeast1-b}"
MACHINE_TYPE="${MACHINE_TYPE:-e2-micro}"

gcloud config set project "$PROJECT_ID"
gcloud compute instances create "$VM_NAME" \
  --zone="$ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family=ubuntu-2404-lts-amd64 \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10GB \
  --tags=http-server \
  --metadata=startup-script='#!/usr/bin/env bash
apt-get update
apt-get install -y docker.io
systemctl enable --now docker'

if ! gcloud compute firewall-rules describe allow-http >/dev/null 2>&1; then
  gcloud compute firewall-rules create allow-http \
    --allow=tcp:80 \
    --target-tags=http-server \
    --description="Allow HTTP traffic to CI/CD demo VM"
fi

gcloud compute instances describe "$VM_NAME" \
  --zone="$ZONE" \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
