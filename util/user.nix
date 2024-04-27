{ pkgs, home-manager, lib, inputs, system, overlays, ... }:
with builtins;
let 
  default_packages = with pkgs; [];
  user-modules = import ./user-modules {
    inherit pkgs config lib;
  };
in
{
  mkSystemUser = { name, groups, uid, shell, ... }:
    {
      programs.zsh.enable = if shell == pkgs.zsh then true else false;
      users.users."${name}" = {
        name = name;
        isNormalUser = true;
        isSystemUser = false;
        extraGroups = groups;
        uid = uid;
        initialPassword = "Welcome1";
        shell = shell;
      };
    };
  mkHMUser = { 
      username
    , user_packages
    , neovim ? false
		, firefox ? false
		, shell ? false
		, git ? false
  }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          home.username = username;
          home.homeDirectory = "/home/" + username;
          home.stateVersion = "23.05";
          programs.home-manager.enable = true;
          home.packages = default_packages ++ user_packages ;
        }
        (lib.mkIf neovim {home.packages = [pkgs.nvim];})
				(lib.mkIf firefox user-modules.firefox)
				(lib.mkIf zsh user-modules.zsh)
				(lib.mkIf git user-modules.git)
      ];
    };

}
