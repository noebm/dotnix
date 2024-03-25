{userConfig, ...}: {
  programs.git.enable = true;
  programs.git.ignores = [
    # nix
    "*.drv"
    "result"
    # rust
    "Cargo.lock"
    "target/"
    # python
    "*.py?"
    "__pycache__/"
    ".venv/"
  ];
  programs.git.userEmail = userConfig.email;
  programs.git.userName = userConfig.name;

  programs.git.delta.enable = true;
}
