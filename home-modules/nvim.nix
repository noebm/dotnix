{pkgs, ...}: {
  programs.nixvim = {
    enable = true;

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
    extraPlugins = with pkgs.vimPlugins; [
      agda-vim
    ];
    extraConfigVim = ''
      command! -buffer -nargs=0 AgdaLoad call AgdaLoad(v:false)
      command! -buffer -nargs=0 AgdaVersion call AgdaVersion(v:false)
      command! -buffer -nargs=0 AgdaReload silent! make!|redraw!
      command! -buffer -nargs=0 AgdaRestartAgda exec s:python_cmd 'AgdaRestart()'
      command! -buffer -nargs=0 AgdaShowImplicitArguments exec s:python_cmd "sendCommand('ShowImplicitArgs True')"
      command! -buffer -nargs=0 AgdaHideImplicitArguments exec s:python_cmd "sendCommand('ShowImplicitArgs False')"
      command! -buffer -nargs=0 AgdaToggleImplicitArguments exec s:python_cmd "sendCommand('ToggleImplicitArgs')"
      command! -buffer -nargs=0 AgdaConstraints exec s:python_cmd "sendCommand('Cmd_constraints')"
      command! -buffer -nargs=0 AgdaMetas exec s:python_cmd "sendCommand('Cmd_metas')"
      command! -buffer -nargs=0 AgdaSolveAll exec s:python_cmd "sendCommand('Cmd_solveAll')"
      command! -buffer -nargs=1 AgdaShowModule call AgdaShowModule(<args>)
      command! -buffer -nargs=1 AgdaWhyInScope call AgdaWhyInScope(<args>)
      command! -buffer -nargs=1 AgdaSetRewriteMode exec s:python_cmd "setRewriteMode('<args>')"
      command! -buffer -nargs=0 AgdaSetRewriteModeAsIs exec s:python_cmd "setRewriteMode('AsIs')"
      command! -buffer -nargs=0 AgdaSetRewriteModeNormalised exec s:python_cmd "setRewriteMode('Normalised')"
      command! -buffer -nargs=0 AgdaSetRewriteModeSimplified exec s:python_cmd "setRewriteMode('Simplified')"
      command! -buffer -nargs=0 AgdaSetRewriteModeHeadNormal exec s:python_cmd "setRewriteMode('HeadNormal')"
      command! -buffer -nargs=0 AgdaSetRewriteModeInstantiated exec s:python_cmd "setRewriteMode('Instantiated')"

      " C-c C-l -> \l
      nnoremap <buffer> <LocalLeader>l :AgdaReload<CR>

      " C-c C-d -> \t
      nnoremap <buffer> <LocalLeader>t :call AgdaInfer()<CR>

      " C-c C-r -> \r
      nnoremap <buffer> <LocalLeader>r :call AgdaRefine("False")<CR>
      nnoremap <buffer> <LocalLeader>R :call AgdaRefine("True")<CR>

      " C-c C-space -> \g
      nnoremap <buffer> <LocalLeader>g :call AgdaGive()<CR>

      " C-c C-g -> \c
      nnoremap <buffer> <LocalLeader>c :call AgdaMakeCase()<CR>

      " C-c C-a -> \a
      nnoremap <buffer> <LocalLeader>a :call AgdaAuto()<CR>

      " C-c C-, -> \e
      nnoremap <buffer> <LocalLeader>e :call AgdaContext()<CR>

      " C-u C-c C-n -> \n
      nnoremap <buffer> <LocalLeader>n :call AgdaNormalize("IgnoreAbstract")<CR>

      " C-c C-n -> \N
      nnoremap <buffer> <LocalLeader>N :call AgdaNormalize("DefaultCompute")<CR>
      nnoremap <buffer> <LocalLeader>M :call AgdaShowModule(\'\')<CR>

      " C-c C-w -> \y
      nnoremap <buffer> <LocalLeader>y :call AgdaWhyInScope(\'\')<CR>
      nnoremap <buffer> <LocalLeader>h :call AgdaHelperFunction()<CR>

      " M-. -> \d
      nnoremap <buffer> <LocalLeader>d :call AgdaGotoAnnotation()<CR>

      " C-c C-? -> \m
      nnoremap <buffer> <LocalLeader>m :AgdaMetas<CR>

      " Show/reload metas
      " C-c C-? -> C-e
      nnoremap <buffer> <C-e> :AgdaMetas<CR>
      inoremap <buffer> <C-e> <C-o>:AgdaMetas<CR>

      " Go to next/previous meta
      " C-c C-f -> C-g
      nnoremap <buffer> <silent> <C-g>  :let _s=@/<CR>/ {!\\| ?<CR>:let @/=_s<CR>2l
      inoremap <buffer> <silent> <C-g>  <C-o>:let _s=@/<CR><C-o>/ {!\\| ?<CR><C-o>:let @/=_s<CR><C-o>2l

      " C-c C-b -> C-y
      nnoremap <buffer> <silent> <C-y>  2h:let _s=@/<CR>? {!\\| \?<CR>:let @/=_s<CR>2l
      inoremap <buffer> <silent> <C-y>  <C-o>2h<C-o>:let _s=@/<CR><C-o>? {!\\| \?<CR><C-o>:let @/=_s<CR><C-o>2l
    '';

    plugins.which-key = {
      enable = true;
    };

    plugins.lualine = {
      enable = true;
    };

    # random useful stuff
    # Refactor blocks / variable using :Refactor
    plugins.refactoring.enable = true;
  };
}
