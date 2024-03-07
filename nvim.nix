{pkgs, ...}: let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-23.11";
  });
in {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    options = {
      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };
      # shortmess += "c";

      number = true;
      relativenumber = true;
      shiftround = true;
      shiftwidth = 2;
      expandtab = true;
      list = true;
    };

    plugins.none-ls = {
      enable = true;
      enableLspFormat = true;
      sources.formatting.black.enable = true;
      sources.formatting.isort = {
        enable = true;
        withArgs = " {\"--profile\", \"black\"} ";
      };
      sources.formatting.alejandra.enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers.nixd.enable = true;
      servers.pyright.enable = true;

      keymaps = {
        diagnostic = {
          "[d" = "goto_next";
          "]d" = "goto_prev";
          "gl" = "open_float";
        };

        lspBuf = {
          K = "hover";
          gr = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          gs = "signature_help";
          "<F2>" = "rename";
        };
      };
    };

    plugins.lsp-format = {
      enable = true;
    };

    plugins.rainbow-delimiters.enable = true;

    plugins.oil.enable = true;

    plugins.treesitter = {
      ensureInstalled = [
        "python"
        "rust"
        "haskell"
      ];
      enable = true;
    };
    plugins.trouble.enable = true;
    plugins.noice.enable = true;
    plugins.nix.enable = true;

    plugins.fugitive.enable = true;
    plugins.gitsigns = {
      enable = true;
      attachToUntracked = false;
    };

    plugins.illuminate = {
      enable = true;
    };

    keymaps = [
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>p";
        options = {
          unique = true;
          desc = "Toggle project tree";
        };
      }
    ];
    plugins.nvim-tree = {
      enable = true;
    };

    plugins.rust-tools = {
      enable = true;
    };

    plugins.which-key = {
      enable = true;
    };
  };
}
