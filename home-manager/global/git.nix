{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      delta
      git-lfs
    ];
    file = {
      ".gitconfig".source = ../../plain-dotfiles/git/gitconfig;
      ".gitignore".source = ../../plain-dotfiles/git/gitignore;
    };
  };

  services.gpg-agent = {
    enable = true;
    ## TODO: GPG
    # enableSshSupport = true;
    # sshKeys = [ "" ];
    # enableExtraSocket = true;
  };
}
