{ lib, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      codelldb
      cpptools
      gdb
      lldb
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [ rr ];
}
