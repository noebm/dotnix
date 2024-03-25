{pkgs, lib, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      # lib.vscode-utils.buildVscodeMarketplaceExtension {
      #   mktplcRef = {

      #   };

      # }
    ];
  };
}
