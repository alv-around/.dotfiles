# Secret Management with Agenix

This project uses [agenix](https://github.com/ryantm/agenix) to manage secrets securely in the Nix configuration.

## Prerequisites

1.  **Private Key**: You need an SSH private key (typically `~/.ssh/id_agenix`) that corresponds to a public key listed in `secrets.nix`.
2.  **Agenix CLI**: Install `agenix` (available in the `devShell` or via `nix shell github:ryantm/agenix`).

## Adding a New Secret

1.  **Generate a new secret file**:
    Create a new `.age` file using the `agenix` CLI:
    ```bash
    # In the root of the repo
    nix run github:ryantm/agenix -- -e home/secrets/my-new-secret.age
    ```
    This will open your `$EDITOR`. Type the secret value, save, and exit.

2.  **Register the secret in `secrets.nix`**:
    Edit `home/secrets/secrets.nix` and add your new file and the public keys that should have access to it:
    ```nix
    let
      alvpad = "ssh-ed25519 ...";
    in {
      "gemini-key.age".publicKeys = [alvpad];
      "my-new-secret.age".publicKeys = [alvpad]; # Add this line
    }
    ```

3.  **Update the secret (if necessary)**:
    If you added a new key to `secrets.nix`, you need to re-encrypt the files:
    ```bash
    nix run github:ryantm/agenix -- --rekey
    ```

4.  **Use the secret in Home Manager**:
    In `home/default.nix` (or any other module), add the secret to the `age.secrets` set:
    ```nix
    age.secrets."my-new-secret" = {
      file = ./secrets/my-new-secret.age;
      # Optional: set path, mode, owner
      # path = "${config.home.homeDirectory}/.my-secret";
    };
    ```

## Accessing Secrets

Secrets are decrypted at activation time and placed in `/run/user/$(id -u)/agenix/` by default, or at the `path` specified in the configuration.

In your Nix code, you can reference the path to the decrypted secret using `config.age.secrets."my-new-secret".path`.
