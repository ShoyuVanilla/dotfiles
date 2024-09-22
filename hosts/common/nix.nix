{ pkgs, ... }:
{
  nix = {
    packages = pkgs.inputs.nix.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
