{userConfig, ...}: {
  programs.git.enable = true;
  programs.git.ignores = [
    # python
    "__pycache__/"
    ".venv"
  ];
  programs.git.userEmail = userConfig.email;
  programs.git.userName = userConfig.name;
}
