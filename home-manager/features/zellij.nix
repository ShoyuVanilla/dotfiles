{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ zellij ];

    file."config.zellij" = {
      source = ../../plain-dotfiles/zellij;
      rercursive = true;
    };
  };
}
