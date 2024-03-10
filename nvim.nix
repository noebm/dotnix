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
      # process delay in ms?
      debounce = 100;

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
      # causes 2.16.2 nix dependency
      # which has a CVE
      # servers.nixd.enable = true;
      servers.pyright.enable = true;

      keymaps = {
        diagnostic = {
          "[d" = {
            action = "goto_next";
            desc = "Goto next diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Goto previous diagnostic";
          };
          "gl" = {
            action = "open_float";
            desc = "Open float";
          };
        };

        lspBuf = {
          K = {
            action = "hover";
            desc = "Hover";
          };
          gr = {
            action = "references";
            desc = "Goto references";
          };
          gd = {
            action = "definition";
            desc = "Goto definition";
          };
          gi = {
            action = "implementation";
            desc = "Goto implementation";
          };
          gt = {
            action = "type_definition";
            desc = "Type definition";
          };
          gs = {
            action = "signature_help";
            desc = "Signature help";
          };
          "<F2>" = {
            action = "rename";
            desc = "Rename variable";
          };
        };
      };
    };

    plugins.lsp-format.enable = true;

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
    plugins.treesitter-context.enable = true;

    plugins.treesitter-refactor = {
      enable = true;
      # highlightCurrentScope.enable = true;
      highlightDefinitions.enable = true;
    };

    plugins.trouble = {
      enable = true;
      autoOpen = true;
      autoClose = true;
    };
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

    # rust plugins
    plugins = {
      rust-tools.enable = true;
      crates-nvim.enable = true;
    };

    plugins.which-key = {
      enable = true;
    };

    plugins.lualine = {
      enable = true;
    };
  };
}
