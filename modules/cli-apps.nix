{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home.packages = with pkgs; [
      bottom
      duf
      dust
      eza
      fd
      gawkInteractive
      gh
      gitui
      lazygit
      gnused
      jq
      less
      ranger
      sd
      tig
      xh
      zoxide
      vivid
    ];
    programs.bat = {
      enable = true;
      config.theme = "gruvbox-dark";
    };
    programs.fzf = {
      enable = true;
      enableFishIntegration = false; # broken
    };
    programs.ripgrep = {
      enable = true;
    };
    programs.skim = {
      enable = true;
    };
  };
}
