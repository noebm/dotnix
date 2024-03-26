{
  pkgs,
  userConfig,
  ...
}: let
  delta = pkgs.fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "f49fd3b012067e34c101d7dfc6cc3bbac1fe5ccc";
    hash = "sha256-33dx/JgLiOY7idNFASoxzTTLFHZcHT7lai4B6vZCwK0=";
  };
in {
  programs.git.enable = true;
  programs.git.ignores = [
    # agda
    "*.agdai"
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
  programs.git.delta.options.features = "colibri";
  programs.git.includes = [
    {path = "${delta}/themes.gitconfig";}
  ];
}
