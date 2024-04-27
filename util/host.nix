{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
let
  host-modules = import ./host-modules {
    inherit pkgs;
  };
in
{
  mkHost =
    { name
    , users
    , hardware_config ? null
    , uefi ? false
    , sound ? false
    , gui ? null
    , isContainer ? false
    }:
    let
      sys_users = (map (u: user.mkSystemUser u) users);
    in
    lib.nixosSystem {
      inherit system;

      modules = [
        {
          imports = [
            (if hardware_config != null then hardware_config else { })
          ] ++ sys_users;

          boot.isContainer = isContainer;

          console.keyMap = "uk";

          time.timeZone = "Europe/London";

          i18n.defaultLocale = "en_GB.UTF-8";

          i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_GB.UTF-8";
            LC_IDENTIFICATION = "en_GB.UTF-8";
            LC_MEASUREMENT = "en_GB.UTF-8";
            LC_MONETARY = "en_GB.UTF-8";
            LC_NAME = "en_GB.UTF-8";
            LC_NUMERIC = "en_GB.UTF-8";
            LC_PAPER = "en_GB.UTF-8";
            LC_TELEPHONE = "en_GB.UTF-8";
            LC_TIME = "en_GB.UTF-8";
          };
          networking = {
            hostName = "${name}";
            networkmanager.enable = true;
          };

          nixpkgs.pkgs = pkgs;
          system.stateVersion = "23.05";
        }
        (lib.mkIf sound host-modules.sound)
        (lib.mkIf (gui != null) (host-modules.gui.setupGui {
          desktopEnvironment = gui.desktopEnv;
          autologin = gui.autologin;
        }))
        (lib.mkIf uefi host-modules.uefi)
      ];
    };
}
