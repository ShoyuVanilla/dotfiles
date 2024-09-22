{ pkgs, system }:

let
  confs = {
    "x86_64-darwin" = {
      version = "1.10.0";
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-darwin.vsix";
      hash = "sha256-caWE0/1DLm8p/kph4tzkLMoWxXwAYje9RTF2g8Ii3Kc=";
    };
  };
  conf = confs.${system};
  version = conf.version;
  url = conf.url;
  hash = conf.hash;
in

pkgs.stdenv.mkDerivation {
  pname = "codelldb";
  inherit version;

  src = pkgs.fetchzip {
    inherit url hash;
    extension = "zip";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/codelldb
    mkdir -p $out/bin
    mv * $out/codelldb/
    chmod +x $out/codelldb/extension/adapter/codelldb
    ln -s $out/codelldb/extension/adapter/codelldb $out/bin/codelldb
  '';
}
