{
  pkgs,
  config,
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
    # direnv
    ".direnv/"
    ".envrc"
  ];

  programs.git.extraConfig = {
    init = {
      defaultBranch = "main";
    };
    # use `--update-refs` by default for stacked branches
    # can be disabled per command via `--no-update-refs`
    rebase = {
      updateRefs = true;
    };
    diff.json.textconv = "jq --sort-keys .";
  };

  programs.git.attributes = [
    "*.json diff=json"
  ];

  programs.git.delta.enable = true;
  programs.git.delta.options.features = "colibri";
  programs.git.includes = [
    {path = "${delta}/themes.gitconfig";}
    {path = config.sops.templates."git_secrets".path;}
  ];

  # git commit --fixup, but automatic
  home.packages = [pkgs.git-absorb];
}
