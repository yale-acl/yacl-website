#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNNER_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-yacl-runner}"
OUT_DIR="${OUT_DIR:-$HOME/yacl-runner-ssh}"
KEY_NAME="${KEY_NAME:-id_ed25519}"
KEY_PATH="${OUT_DIR}/${KEY_NAME}"
REMOTE_HOST="${REMOTE_HOST:-cs-www.cs.yale.edu}"
REMOTE_USER="${REMOTE_USER:-fz243}"

if [[ ! -f /etc/os-release ]]; then
  echo "Unsupported host: /etc/os-release not found" >&2
  exit 1
fi

. /etc/os-release

if [[ "${ID:-}" != "ubuntu" || "${VERSION_ID:-}" != "24.04" ]]; then
  echo "This script is intended for Ubuntu 24.04. Detected: ${PRETTY_NAME:-unknown}" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but not installed or not on PATH." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
  echo "Installing required host utilities..."
  sudo apt-get update
  sudo apt-get install -y curl git
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not reachable. Make sure Docker is running and your user can access it." >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"
chmod 700 "${OUT_DIR}"

if [[ ! -f "${KEY_PATH}" ]]; then
  echo "Generating deploy SSH key at ${KEY_PATH} ..."
  ssh-keygen -t ed25519 -f "${KEY_PATH}" -N "" -C "yacl deploy key"

  cat > "${OUT_DIR}/config" <<EOF
Host ${REMOTE_HOST}
  User ${REMOTE_USER}
  IdentityFile /home/runner/.ssh/${KEY_NAME}
  IdentitiesOnly yes
EOF

  ssh-keyscan "${REMOTE_HOST}" > "${OUT_DIR}/known_hosts"
  chmod 600 "${KEY_PATH}" "${OUT_DIR}/config" "${OUT_DIR}/known_hosts"
  chmod 644 "${KEY_PATH}.pub"
else
  echo "Reusing existing deploy SSH key at ${KEY_PATH}"
fi

echo "Building Docker image '${IMAGE_NAME}' from ${RUNNER_DIR} ..."
docker build -t "${IMAGE_NAME}" "${RUNNER_DIR}"

cat <<EOF

Build complete.

Image:
  ${IMAGE_NAME}

Next steps:
1. Add the public key to the deploy target:
   ssh-copy-id -i \$HOME/yacl-runner-ssh/id_ed25519.pub fz243@cs-www.cs.yale.edu
2. Create a fresh GitHub runner registration token for:
   https://github.com/yale-acl
3. Start the runner with Docker Compose:
   cd deployment/runner
   export GITHUB_URL=https://github.com/yale-acl
   export RUNNER_TOKEN=YOUR_REGISTRATION_TOKEN
   export SSH_HOST_DIR=\$HOME/yacl-runner-ssh
   docker compose up -d
EOF
