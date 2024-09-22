{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        marp-cli
      ];
    };
  };
}
