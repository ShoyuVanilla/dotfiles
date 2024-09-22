{ pkgs, system }:

let
  confs = {
    "x86_64-darwin" = {
      version = "1.19.0";
      url = "https://github.com/microsoft/vscode-cpptools/releases/download/v1.19.9/cpptools-osx.vsix";
      hash = "sha256-eAIwkAnfIxnRwciJRnS4QpJBkV2MORFhIZla2TNU80c=";
    };
  };
  conf = confs.${system};
  version = conf.version;
  url = conf.url;
  hash = conf.hash;
in
pkgs.stdenv.mkDerivation {
  pname = "cpptools";
  inherit version;

  src = pkgs.fetchzip {
    inherit url hash;
    extension = "zip";
    stripRoot = false;
  };

  buildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/cpptools
    mkdir -p $out/bin
    mv * $out/cpptools/
    chmod +x $out/cpptools/extension/debugAdapters/bin/OpenDebugAD7
    ln -s $out/cpptools/extension/debugAdapters/bin/OpenDebugAD7 $out/bin/OpenDebugAD7
  '';
}
