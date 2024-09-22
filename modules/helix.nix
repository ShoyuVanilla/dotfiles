{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        helix
      ];
      file.".config/helix" = {
        source = ../plain-dotfiles/helix;
        recursive = true;
      };
    };
  };
}
