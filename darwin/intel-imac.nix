{ pkgs, vars, ... }:

{
  imports = (import ./modules);

  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  networking = {
    computerName = "iMac";
    hostName = "iMac";
  };

  skhd.enable = false;
  yabai.enable = false;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];
    variables = {
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      TERM = "${vars.terminal}";
    };
    systemPackages = with pkgs; [ git ];
  };

  programs = {
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      "defaultbrowser"
      "docker"
      "podman"
      "mingw-w64"
    ];
    casks = [
      "google-chrome"
      "slack"
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    #  auto-optimise-store is buggy. https://github.com/NixOS/nix/issues/7273
    extraOptions = ''
      auto-optimise-store = false
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
        persistent-apps = [
          "/Applications/Alacritty.app"
          "/Applications/Firefox.app"
          "/Applications/Slack.app"
        ];
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';
    stateVersion = 4;
  };

  home-manager.users.${vars.user} =
    { lib, config, ... }:

    {
      home = {
        stateVersion = "24.05";
        packages = with pkgs; [ duti ];
        activation.applyDutiConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          PATH="${config.home.path}/bin:/usr/local/bin:$PATH"
          # `homebrew.brews = [ defaultbrowser ]`
          defaultbrowser firefox
          ## duti makes error -54 for browsers!
          # duti -s org.mozilla.firefox public.html all
        '';
      };

      programs = {
        home-manager.enable = true;
      };
    };
}
