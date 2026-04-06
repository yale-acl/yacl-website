#!/usr/bin/env bash

set -euo pipefail

RUNNER_HOME="/home/runner"
RUNNER_USER="runner"
SSH_SOURCE_DIR="${SSH_SOURCE_DIR:-/runner-ssh}"
SSH_TARGET_DIR="${SSH_TARGET_DIR:-${RUNNER_HOME}/.ssh}"
SSH_KEY_PATH="${RUNNER_HOME}/.ssh/id_ed25519"

if [[ "$(id -u)" -eq 0 ]]; then
  mkdir -p "${SSH_TARGET_DIR}" "${RUNNER_HOME}/_work"
  chmod 700 "${SSH_TARGET_DIR}"

  if [[ -d "${SSH_SOURCE_DIR}" ]]; then
    cp -a "${SSH_SOURCE_DIR}/." "${SSH_TARGET_DIR}/"
  fi

  chown -R "${RUNNER_USER}:${RUNNER_USER}" "${SSH_TARGET_DIR}" "${RUNNER_HOME}/_work"
  exec runuser -u "${RUNNER_USER}" -- env HOME="${RUNNER_HOME}" PATH="${PATH}" "$0" "$@"
fi

cd /home/runner

: "${GITHUB_URL:?Set GITHUB_URL to the repo or org URL, for example https://github.com/yale-acl/yacl-website}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN to a GitHub runner registration token}"

RUNNER_NAME="yale-runner"
RUNNER_LABELS="yacl-deploy"
RUNNER_WORKDIR="_work"

cleanup() {
  if [[ -f .runner ]]; then
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}" || true
  fi
}

trap cleanup EXIT

if [[ ! -f "${SSH_KEY_PATH}" ]]; then
  echo "SSH key not found at ${SSH_KEY_PATH}" >&2
  exit 1
fi

eval "$(ssh-agent -s)"
ssh-add "${SSH_KEY_PATH}"

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
