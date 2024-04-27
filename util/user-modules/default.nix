{ config, pkgs, lib, ... }: rec {
	firefox = import ./firefox.nix { inherit pkgs config; };
	zsh = import ./zsh.nix { inherit pkgs config lib; };
	git = import ./git.nix { inherit pkgs config; };
}
