{ pkgs, ... }:
{
  programs.git = {
    extraConfig.diff.json.textconv = "jq --sort-keys .";
    attributes = [ "*.json diff=json" ];
  };
  home.packages = [ pkgs.jq ];
}
