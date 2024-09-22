{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [
        dotnet
        protobuf
        jetbrains.rider
      ];
      file.".ideavimrc".source = ../plain-dotfiles/jetbrains/ideavimrc;
    };
  };
}
