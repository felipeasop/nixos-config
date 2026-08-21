{ inputs, ... }: {
  den.aspects.neovim = {
    homeManager = { pkgs, ... }: {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        extraLuaConfig = builtins.readFile "${inputs.self}/modules/apps/dev/editors/nvim.nix/init.lua";

        plugins = with pkgs.vimPlugins; [
          plenary-nvim
          telescope-nvim
          nvim-treesitter.withAllGrammars
          lualine-nvim
          gitsigns-nvim
          nvim-autopairs
          nvim-lspconfig
          catppuccin-nvim
        ];
      };
    };
  };
}
