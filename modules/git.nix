{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        delta
        git-lfs
      ];
      file = {
        ".gitconfig".source = ../plain-dotfiles/git/gitconfig;
        ".gitignore".source = ../plain-dotfiles/git/gitignore;
      };
    };
  };
}
