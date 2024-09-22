{
  lib,
  pkgs,
  vars,
  ...
}:

{
  home-manager.users.${vars.user} = {
    home.packages =
      with pkgs;
      [
        go
        nodejs_22
        jdk
        protobuf
        (python3.withPackages (python-pkgs: [
          python-pkgs.mdformat
          # TODO: remove these and use basedpyright
          python-pkgs.python-lsp-server
          python-pkgs.python-lsp-ruff
          (pkgs.callPackage ../packages/pylsp-inlay-hints.nix {
            pythonPackages = pkgs.python3Packages;
            pdm = pkgs.pdm;
          })
        ]))
        rustup

        # Language Servers
        nil # Nix
        nixfmt-rfc-style
        nodePackages.bash-language-server
        ruff
        taplo # TOML
        gopls
        golangci-lint
        golangci-lint-langserver
        libclang # C, C++
        cmake-language-server
        nodePackages.typescript-language-server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        yaml-language-server
        dockerfile-language-server-nodejs
        docker-compose-language-service
        typst-lsp
        typstfmt
        lua-language-server
        markdown-oxide
        csharp-ls

        # Debuggers
        codelldb
        cpptools
        gdb
        lldb
        # # Not available on macOS
        # rr

        vscode
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [ rr ];
    # ++ (if pkgs.stdenv.isDarwin then [ ] else [ rr ]);
  };
}
