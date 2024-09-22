{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup

    go
    gopls
    golangci-lint
    golangci-lint-langserver

    libclang # C, C++

    nodePackages.typescript-language-server
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint

    dotnet
    csharp-ls

    jdk

    nodePackages.bash-language-server

    nil # Nix
    nixfmt-rfc-style

    (python3.withPackages (python-pkgs: [ python-pkgs.mdformat ]))
    basedpyright

    lua-language-server

    protobuf

    cmake-language-server

    dockerfile-language-server-nodejs
    docker-compose-language-service

    yaml-language-server

    taplo # TOML

    markdown-oxide

    typst-lsp
    typstfmt

    vscode
  ];
}
