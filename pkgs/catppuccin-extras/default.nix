{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  themeList,
}:
let
  pname = "catppuccin-extras";

  selectedSources = map (themeName: builtins.getAttr themeName sources) themeList;

  sources = {
    alacritty = fetchFromGitHub {
      name = "alacritty";
      owner = "catppuccin";
      repo = "alacritty";
      rev = "94800165c13998b600a9da9d29c330de9f28618e";
      hash = "";
    };
  };
in
stdenvNoCC.mkDerivation { srcs = selectedSources; }
