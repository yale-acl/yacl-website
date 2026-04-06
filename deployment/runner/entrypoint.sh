#!/usr/bin/env bash

set -euo pipefail

cd /home/runner

: "${GITHUB_URL:?Set GITHUB_URL to the repo or org URL, for example https://github.com/yale-acl/yacl-website}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN to a GitHub runner registration token}"

RUNNER_NAME="${RUNNER_NAME:-$(hostname)}"
RUNNER_LABELS="${RUNNER_LABELS:-yacl-deploy}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-_work}"
SSH_KEY_PATH="${SSH_KEY_PATH:-}"

cleanup() {
  if [[ -f .runner ]]; then
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
  fi
}

trap cleanup EXIT

if [[ -n "${SSH_KEY_PATH}" ]]; then
  if [[ ! -f "${SSH_KEY_PATH}" ]]; then
    echo "SSH key not found at ${SSH_KEY_PATH}" >&2
    exit 1
  fi

  eval "$(ssh-agent -s)"
  ssh-add "${SSH_KEY_PATH}"
fi

if [[ ! -f .runner ]]; then
  ./config.sh \
    --url "${GITHUB_URL}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --work "${RUNNER_WORKDIR}" \
    --unattended \
    --replace
fi

exec ./run.sh
