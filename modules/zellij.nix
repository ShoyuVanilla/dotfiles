{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        zellij
      ];
      file.".config/zellij" = {
        source = ../plain-dotfiles/zellij;
        recursive = true;
      };
    };
  };
}
