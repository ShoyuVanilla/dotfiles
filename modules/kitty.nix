{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        kitty
      ];
      file.".config/kitty" = {
        source = ../plain-dotfiles/kitty;
        recursive = true;
      };
    };
  };
}
