#!/usr/bin/env bash
set -euo pipefail

repository=https://github.com/hingst-it/panko

require_version() {
  if [ "${ASDF_INSTALL_TYPE:-version}" != version ]; then
    echo 'panko supports released versions, not source refs' >&2
    exit 1
  fi
  if ! [[ "${ASDF_INSTALL_VERSION:-}" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo 'expected a release version such as 0.0.1' >&2
    exit 1
  fi
}

download_release() {
  require_version
  local platform arch archive expected actual checksums
  case "$(uname -s)" in
    Darwin) platform=darwin ;;
    Linux) platform=linux ;;
    *) echo 'panko asdf plugin supports macOS and Linux' >&2; exit 1 ;;
  esac
  case "$(uname -m)" in
    arm64|aarch64) arch=arm64 ;;
    x86_64|amd64) arch=amd64 ;;
    *) echo 'panko supports AMD64 and ARM64' >&2; exit 1 ;;
  esac
  archive="panko_${ASDF_INSTALL_VERSION}_${platform}_${arch}.tar.gz"
  mkdir -p "$ASDF_DOWNLOAD_PATH"
  checksums="$ASDF_DOWNLOAD_PATH/SHA256SUMS"
  curl --fail --location --silent --show-error --retry 3 \
    "$repository/releases/download/v$ASDF_INSTALL_VERSION/SHA256SUMS" -o "$checksums"
  curl --fail --location --silent --show-error --retry 3 \
    "$repository/releases/download/v$ASDF_INSTALL_VERSION/$archive" -o "$ASDF_DOWNLOAD_PATH/$archive"
  expected=$(awk -v name="$archive" '$2 == name {print $1}' "$checksums")
  if ! [[ "$expected" =~ ^[0-9a-f]{64}$ ]]; then
    echo "missing or invalid checksum for $archive" >&2; exit 1
  fi
  if command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$ASDF_DOWNLOAD_PATH/$archive" | awk '{print $1}')
  else
    actual=$(shasum -a 256 "$ASDF_DOWNLOAD_PATH/$archive" | awk '{print $1}')
  fi
  if [ "$actual" != "$expected" ]; then
    echo "checksum mismatch for $archive" >&2; exit 1
  fi
  tar -xzf "$ASDF_DOWNLOAD_PATH/$archive" -C "$ASDF_DOWNLOAD_PATH"
}
