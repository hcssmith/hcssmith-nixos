{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR/master";
    my-nix-overlay = {
      url = "path:/home/hcssmith/Projects/my-nix-overlay";
      #url = "github:hcssmith/my-nix-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nix-neovim = {
			url = "github:hcssmith/nix-neovim";
			inputs.nixpkgs.follows = "nixpkgs";
		};

  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      inherit (nixpkgs) lib;
      util = import ./util {
        inherit system pkgs home-manager lib inputs; overlays = (pkgs.overlays);
      };

      inherit (util) user;
      inherit (util) host;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.my-nix-overlay.overlay
          inputs.nur.overlay
					inputs.nix-neovim.overlays.default
        ];
      };

      system = "x86_64-linux";

      inherit (inputs.home-manager) defaultPackage ;
    in
    {
      nixosConfigurations = {
        laptop = host.mkHost {
          name = "laptop";
          hardware_config = ./hardware/laptop.nix;
          uefi = true;
          sound = true;
          gui = {
            desktopEnv = "gnome";
            autologin = true;
          };
          users = [
            {
              name = "hcssmith";
              groups = [ "wheel" "networkmanager" ];
              uid = 1000;
              shell = pkgs.zsh;
            }
          ];
        };
      };

      homeConfigurations = {
        hcssmith = user.mkHMUser {
          username = "hcssmith";
          user_packages = with pkgs; [
            ripgrep
          ];
          neovim = true;
					firefox = true;
					shell = true;
					git = true;
        };
      };

      packages."${system}".default = defaultPackage.${system};
    };
}
