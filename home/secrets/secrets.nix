# secrets/secrets.nix
let
  # Replace this string with the actual contents of your ~/.ssh/id_agenix.pub
  alvpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSTh28qWVr5yBhWoLheLgz3/Jwnlxe4vX4m4RMGLreH alv@alvpad";
in {
  "gemini-key.age".publicKeys = [alvpad];
}
