{
  pkgs,
  config,
  lib,
  ...
}:

{
  users.mutableUsers = false;
  users.users.shoyu = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
