{
  lib,
  config,
  pkgs,
}:

{
  home = {
    packages = with pkgs; [
      defaultbrowser
      unnaturalscrollwheels
    ];
    activation.setDefaultBrowser = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${config.home.path}/bin:/usr/local/bin:$PATH"
      defaultbrowser firefox
    '';
  };
}
