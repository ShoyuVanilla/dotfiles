{
  pkgs,
  vars,
  lib,
  ...
}:

let
  fromGitHub =
    rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
in

{
  home-manager.users.${vars.user} = {
    xdg.configFile = {
      "nvim/init.lua".text = ''
        vim.loader.enable()
        require('shoyu')
      '';
      "nvim/lua/shoyu" = {
        source = ../plain-dotfiles/nvim/lua/shoyu;
        recursive = true;
      };
      "nvim/after/ftplugin" = {
        source = ../plain-dotfiles/nvim/after/ftplugin;
        recursive = true;
      };
    };
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs.vimPlugins; [
        bufdelete-nvim
        catppuccin-nvim
        cmp_luasnip
        cmp-nvim-lsp
        comment-nvim
        conform-nvim
        diffview-nvim
        indent-blankline-nvim
        lsp_lines-nvim
        lualine-nvim
        luasnip
        mini-nvim
        neogit
        # noice-nvim
        (fromGitHub "09102ca2e9a3e9302119fdaf7a059a034e4a626d" "main" "folke/noice.nvim")
        nui-nvim
        nvim-autopairs
        nvim-cmp
        nvim-cokeline
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lspconfig
        nvim-notify
        nvim-surround
        nvim-treesitter.withAllGrammars
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-web-devicons
        oil-nvim
        orgmode
        plenary-nvim
        telescope-dap-nvim
        telescope-nvim
        telescope-ui-select-nvim
        telescope-undo-nvim
        todo-comments-nvim
        undotree
        vim-fugitive
        vim-sneak
        # Use recent version of gitsigns for nav_hunk feature
        (fromGitHub "52f8da33cc0cadbf1164c4a91c8bfd6895533d67" "main" "lewis6991/gitsigns.nvim")
        # Harpoon v2
        (fromGitHub "0378a6c428a0bed6a2781d459d7943843f374bce" "harpoon2" "ThePrimeagen/harpoon")
        # Harpoonline
        (fromGitHub "6ba9dca0fc42781c4a0ff89932bd386d6bbd75f8" "main" "abeldekat/harpoonline")
        # incline-nvim
        (fromGitHub "3e8edbc457daab8dba087dbba319865a912be7f9" "main" "b0o/incline.nvim")
        # statuscol
        (fromGitHub "e9e4c30b68abe456d80a0b144149ebf3f4527ed8" "0.10" "luukvbaal/statuscol.nvim")
        # hydra
        (fromGitHub "8578056a2226ed49fc608167edc143a87f75d809" "main" "nvimtools/hydra.nvim")
      ];
      extraConfig = '''';
    };
  };
}
