{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user} = {
    home = {
      packages = with pkgs; [ tridactyl-native ];
    };
    xdg.configFile = {
      "tridactyl/tridactylrc".source = ../plain-dotfiles/firefox/tridactylrc;
    };
    programs.browserpass.enable = true;
    programs.firefox = {
      enable = true;
      package =
        if pkgs.lib.strings.hasSuffix "darwin" pkgs.system then pkgs.firefox-bin else pkgs.firefox;
      nativeMessagingHosts = with pkgs; [
        browserpass
        tridactyl-native
      ];
      profiles.shoyuvanilla = {
        bookmarks = { };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          browserpass
          tridactyl
          ublock-origin
        ];
        userChrome = builtins.readFile ../plain-dotfiles/firefox/userChrome.css;
        settings = {
          "browser.startup.homepage" = "https://news.ycombinator.com/";
          "nativeMessaging" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Perf options
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "widget.dmabuf.force-enabled" = true;

          # ESNI is deprecated ECH is recommended
          "network.dns.echconfig.enabled" = true;

          # Privacy
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          # Disable telemetry for privacy reasons
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.urlbar.eventTelemetry.enabled" = false;

          "beacon.enabled" = false; # No bluetooth location BS in my webbrowser please
          "device.sensors.enabled" = false; # This isn't a phone
          "geo.enabled" = false; # Disable geolocation alltogether

          # Disable some useless stuff
          "extensions.pocket.enabled" = false; # disable pocket, save links, send tabs
          "extensions.abuseReport.enabled" = false; # don't show 'report abuse' in extensions
          "extensions.formautofill.creditCards.enabled" = false; # don't auto-fill credit card information
          "identity.fxaccounts.enabled" = false; # disable firefox login
          "identity.fxaccounts.toolbar.enabled" = false;
          "identity.fxaccounts.pairing.enabled" = false;
          "identity.fxaccounts.commands.enabled" = false;
          "browser.contentblocking.report.lockwise.enabled" = false; # don't use firefox password manger
          "browser.uitour.enabled" = false; # no tutorial please
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          # disable annoying web features
          "dom.push.enabled" = false; # no notifications, really...
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false; # you don't need to see my battery...

          # This allows firefox devs changing options for a small amount of users to test out stuff.
          # Not with me please ...
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          # Allow executing JS in the dev console
          "devtools.chrome.enabled" = true;

          "browser.download.panel.shown" = true;
        };
      };
    };
    ## xdg.mimeApps is linux only
    # xdg = {
    #   enable = true;
    #   mimeApps = {
    #     enable = true;
    #     defaultApplications = {
    #       "text/html" = "firefox.desktop";
    #       "x-scheme-handler/http" = "firefox.desktop";
    #       "x-scheme-handler/https" = "firefox.desktop";
    #       "x-scheme-handler/ftp" = "firefox.desktop";
    #       "x-scheme-handler/chrome" = "firefox.desktop";
    #       "x-scheme-handler/about" = "firefox.desktop";
    #       "x-scheme-handler/unknown" = "firefox.desktop";
    #       "application/x-extension-htm" = "firefox.desktop";
    #       "application/x-extension-html" = "firefox.desktop";
    #       "application/x-extension-shtml" = "firefox.desktop";
    #       "application/xhtml+xml" = "firefox.desktop";
    #       "application/x-extension-xhtml" = "firefox.desktop";
    #       "application/x-extension-xht" = "firefox.desktop";
    #     };
    #   };
    # };
  };
}
