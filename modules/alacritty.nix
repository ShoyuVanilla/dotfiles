{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        alacritty
      ];
      file.".config/alacritty" = {
        source = ../plain-dotfiles/alacritty;
        recursive = true;
      };
    };
  };
}
