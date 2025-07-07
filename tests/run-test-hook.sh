#!/usr/bin/env bash

# This script is designed to be sourced or executed as the shellHook
# for the Home-Manager test development shell.

# It sets up a temporary HOME, applies Home-Manager, sources the HM profile,
# and then runs the actual test script.

set -euo pipefail # Exit on error, exit on unset variable, pipefail

# This variable will be passed from the flake.nix to this script.
# It contains the space-separated list of package names to test.
# Example: PACKAGES_TO_TEST="git neovim htop"
: "${PACKAGES_TO_TEST?Error: PACKAGES_TO_TEST environment variable not set.}"

echo "--- Preparing Home-Manager test environment ---"

# Create a temporary HOME directory for full isolation.
# Home-Manager will build its profile inside this temp directory.
export HOME="$(mktemp -d)"
echo "Using temporary HOME: $HOME"

# Ensure the temporary HOME directory is cleaned up on exit (success or failure)
cleanup() {
  if [ -n "$HOME" ] && [ -d "$HOME" ]; then
    echo "Cleaning up temporary HOME directory: $HOME"
    rm -rf "$HOME"
  fi
}
trap cleanup EXIT

# Get the path to the home-manager binary from the environment.
# This assumes the home-manager package is in the devShell's buildInputs.
if ! command -v home-manager >/dev/null 2>&1; then
  echo "Error: 'home-manager' command not found in PATH within the dev shell."
  echo "Ensure 'home-manager.packages.${NIX_SYSTEM}.home-manager' is in buildInputs."
  exit 1
fi
HM_BIN=$(command -v home-manager)

# Applying Home-Manager configuration
echo "Applying Home-Manager configuration..."
# We use PWD for the flake path as it's the current working directory from where nix develop is run.
# Adjust 'myUser' if your homeConfiguration is named differently in flake.nix
"$HM_BIN" switch --flake "$PWD"#myUser --impure

if [ $? -ne 0 ]; then
  echo "Error: Home-Manager switch failed in temporary environment."
  exit 1 # Exit with error if HM switch fails
fi

echo "Home-Manager configuration applied successfully to $HOME."

# Source the Home-Manager generated profile to ensure packages are in PATH
# This is CRUCIAL for the test script to find the commands installed by HM.
# The order of these checks matters as different HM/Nix versions might put them differently.
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  echo "Sourcing Home-Manager session variables..."
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  echo "Sourcing Nix profile variables..."
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  echo "Error: Could not find Home-Manager session or Nix profile sourcing script."
  echo "Tests might fail if PATH is not correctly set."
  exit 1 # Indicate a critical setup failure
fi

echo "--- Running dotfiles tests with nix develop ---"

# Execute your standalone test script.
# We pass the list of dependencies as arguments to the test script.
# The path to test.sh is relative to the flake's root (which is $PWD).
"$PWD"/tests/test.sh ${PACKAGES_TO_TEST}

TEST_RESULT=$? # Capture the exit code of the test script

if [ $TEST_RESULT -ne 0 ]; then
  echo "Home-Manager integration tests FAILED for nix develop!"
  exit 1 # Exit with non-zero to indicate failure
else
  echo "Home-Manager integration tests PASSED for nix develop!"
  # No explicit exit 0 here, as the `trap cleanup EXIT` handles successful exit.
fi
