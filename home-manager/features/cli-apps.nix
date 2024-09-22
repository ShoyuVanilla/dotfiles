{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    skim
    fzf
    bottom
    duf
    dust
    eza
    fd
    gawkInteractive
    gh
    gitui
    lazygit
    tig
    gnused
    jq
    less
    ranger
    sd
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
}
