{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ alacritty ];

    file.".config/alacritty.toml".source = ../../../plain-dotfiles/alacritty/alacritty.toml;
  };
}
