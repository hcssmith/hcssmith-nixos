{ pkgs, ... }: rec {
  sound = import ./sound.nix { inherit pkgs; };
  gui = import ./gui.nix { inherit pkgs; };
  uefi = import ./uefi.nix { inherit pkgs; };
}

