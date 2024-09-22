{
  inputs,
  nixpkgs-unstable,
  darwin,
  home-manager-unstable,
  vars,
  overlays,
  ...
}:

{
  intel-imac = darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    specialArgs = {
      inherit inputs vars;
    };
    pkgs = import nixpkgs-unstable {
      system = "x86_64-darwin";
      config.allowUnfree = true;
      overlays = overlays ++ [
        (import ../overlays)
        inputs.nixpkgs-firefox-darwin.overlay
      ];
    };
    modules = [
      ./intel-imac.nix
      ../modules/alacritty.nix
      ../modules/kitty.nix
      ../modules/cli-apps.nix
      ../modules/dev.nix
      ../modules/git.nix
      ../modules/helix.nix
      ../modules/nvim.nix
      ../modules/zellij.nix
      ../modules/zsh.nix
      ../modules/office.nix
      ../modules/firefox.nix

      home-manager-unstable.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";

        ## Not works on darwin
        # home-manager.users.${vars.user} = {
        #   imports = [ (inputs.impermanence + "/home-manager.nix") ];
        #   home = {
        #     persistence."/nix/persist/home/${vars.user}".directories = [ ".mozilla/firefox" ];
        #   };
        # };
      }
    ];
  };
}
