#!/usr/bin/env bash

set -euo pipefail # Exit on error, exit on unset variable, pipefail

# This script asserts that dotfile dependencies are correctly installed
# by Home-Manager and are linked to the Nix store.

# Usage: This script expects the list of commands to check as positional arguments.
# Example: If called as "./test.sh git neovim htop", it will check for git, neovim, and htop.

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <command1> [command2] ..."
  echo "Checks if the specified commands exist and originate from the Nix store."
  exit 1
fi

echo "--- Starting dotfiles dependency tests ---"

# Ensure HOME is set, as Home-Manager typically operates relative to it
if [ -z "${HOME:-}" ]; then
  echo "Error: HOME environment variable is not set. Cannot proceed with tests."
  exit 1
fi

echo "Current HOME: $HOME"

# Check if .bashrc (or your primary shell config) is sourced and HM is in effect
# This is a good sanity check to ensure the HM environment is loaded.
# We expect the Dockerfile's CMD to source the HM profile.
if ! command -v home-manager >/dev/null 2>&1; then
  echo "Warning: 'home-manager' command not found in PATH. Ensure Home-Manager environment is loaded."
  # We won't exit here immediately, as some packages might still be in path.
  # But it's a strong indicator something is wrong.
fi

# Loop through each command provided as an argument
for cmd_name in "$@"; do
  echo "Checking command: $cmd_name"

  # 1. Assert the command exists in the PATH
  if ! command -v "$cmd_name" >/dev/null 2>&1; then
    echo "FAIL: Command '$cmd_name' not found in PATH."
    exit 1
  fi
  echo "PASS: Command '$cmd_name' found."

  # Get the full path to the command
  cmd_path=$(command -v "$cmd_name")
  echo "  Path: $cmd_path"

  # 2. Assert the path to the command corresponds to the Nix store
  # Nix store paths typically start with /nix/store/
  if [[ "$cmd_path" == "${HOME}/.nix-profile/bin/${cmd_name}" ]]; then
    echo "PASS: Command '$cmd_name' path originates from the Nix store."
  else
    echo "FAIL: Command '$cmd_name' path ('$cmd_path') does NOT originate from the Nix store."
    exit 1
  fi
done

echo "--- All dotfiles dependency tests PASSED! ---"
