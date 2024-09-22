final: prev:

let
  pkgs = prev;
  system = prev.system;
in
{
  codelldb = final.callPackage ../packages/codelldb.nix { inherit pkgs system; };
  cpptools = final.callPackage ../packages/cpptools.nix { inherit pkgs system; };
}