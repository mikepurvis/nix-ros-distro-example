{
  description = "ROS packages generated outside nix-ros-overlay, built with its machinery";

  inputs = {
    nix-ros-overlay.url = "github:mikepurvis/nix-ros-overlay/mkrosdistro-AN2ATG0";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
  };

  outputs = { self, nix-ros-overlay, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {
      inherit system;
      overlays = [ nix-ros-overlay.overlays.default self.overlays.default ];
    }));
  in {
    overlays.default = import ./overlay.nix nix-ros-overlay.lib;

    legacyPackages = forAllSystems (pkgs: {
      inherit (pkgs.rosPackages) jazzy banana example-standalone;
    });

    packages = forAllSystems (pkgs: {
      inherit (pkgs.rosPackages.banana) angles ackermann-msgs example-interfaces;
      env = pkgs.rosPackages.banana.buildEnv {
        paths = with pkgs.rosPackages.banana; [ angles ackermann-msgs example-interfaces ];
      };
    });
  };
}
