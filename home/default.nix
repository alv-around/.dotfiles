{ config, pkgs, ... }:

{
  # Define the packages you want available in your user environment.
  # These are the same packages you listed previously.
  home.packages = with pkgs; [
    fd
    fzf
    neovim
    starship
    stow       # Ensure stow is available for your workflow.
    tmux
    wezterm
    zoxide
    zsh
    gcc        # GNU Compiler Collection
    go         # Go programming language
    rustup     # Rust toolchain installer
    typescript
  ];

  # You can optionally add other basic Home Manager settings here,
  # but per your request, we'll keep it minimal.
  # For example, to enable home-manager to manage itself:
  programs.home-manager.enable = true;

  # Avoid displaying news on activation
  news.display = "silent";

  # Ensure that your shell picks up changes by sourcing a specific file
  # This is often needed for Zsh, Fish, etc. For Bash, it's usually handled automatically.
  # If you use Zsh and source your .zshrc in your global Zsh config,
  # the PATH changes from home-manager will usually be picked up.
  # If you still have issues with programs not being in PATH, you might need to add:
  # home.sessionPath = [ "$HOME/.nix-profile/bin" ];
  # But this is usually handled by home-manager or the Nix install script.
}
