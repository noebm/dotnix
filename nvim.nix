{
  # colorschemes.tokyonight = {
  #   enable = true;
  #   style = "night";
  # };

  colorschemes.catppuccin = {
    enable = true;
    flavour = "mocha";
  };

  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  options = {
    # shortmess += "c";

    number = true;
    relativenumber = true;
    shiftround = true;
    shiftwidth = 2;
    expandtab = true;
    list = true;
  };

  plugins = {
    cmp-snippy.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-path.enable = true;
    cmp-treesitter.enable = true;
    nvim-cmp = {
      enable = true;

      snippet.expand = "snippy";

      sources = [
        {name = "snippy";}
        {name = "nvim_lsp";}
        {name = "nvim_lsp_document_symbol";}
        {name = "nvim_lsp_signature_help";}
        {name = "buffer";}
        {name = "cmdline";}
        {name = "path";}
        {name = "treesitter";}
      ];

      # preliminary
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = {
          action = ''cmp.mapping.select_next_item()'';
        };
        "<S-Tab>" = {
          action = ''cmp.mapping.select_prev_item()'';
        };
      };
    };
  };
  # plugins.cmp-conventionalcommits.enable = true;

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
    sources.formatting.rustfmt.enable = true;
  };

  plugins.lsp = {
    enable = true;
    # causes 2.16.2 nix dependency
    # which has a CVE
    # servers.nixd.enable = true;
    servers.pyright.enable = true;
    servers.hls.enable = true;
    servers.bashls.enable = true;
    servers.nil_ls.enable = true;
    # servers.ccls.enable = true;

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

  # noice seems to cause delay [nixos-23.11]
  # plugins.noice.enable = true;

  plugins.nvim-autopairs.enable = true;

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

  # agda

  plugins.which-key = {
    enable = true;
  };

  plugins.lualine = {
    enable = true;
  };

  # random useful stuff
  # Refactor blocks / variable using :Refactor
  plugins.refactoring.enable = true;
}
