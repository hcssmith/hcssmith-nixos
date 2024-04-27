{ pkgs, ... }:
{
  setupGui =
    { desktopEnvironment
    , autologin
    }:
    let
      setup =
        if desktopEnvironment == "gnome" then {
          services.xserver.enable = true;
          services.xserver.displayManager.gdm = true;
          services.xserver.desktopManager.gnome.enable = true;
        } else { };
      autoLogin =
        if autologin == true then {
          services.xserver.displayManager.autoLogin.enable = true;
          services.xserver.displayManager.autoLogin.user = "hcssmith";
          systemd.services."getty@tty1".enable = false;
          systemd.services."autovt@tty1".enable = false;
        } else { };
    in
    {
      services.xserver = {
        layout = "gb";
        xkbVariant = "";
      };
    } // setup // autoLogin;
}
