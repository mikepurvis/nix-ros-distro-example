{
  description = "ROS packages generated outside nix-ros-overlay, built with its machinery";

  inputs = {
    nix-ros-overlay.url = "github:mikepurvis/nix-ros-overlay/mkrosdistro-AN2ATG0";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    # The rosdistro tree nix-ros-overlay generates from. mango's index and
    # distribution file are laid over a copy of it, for rosdep and the rest.
    rosdistro.follows = "nix-ros-overlay/rosdistro";
  };

  outputs = { self, nix-ros-overlay, nixpkgs, rosdistro }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {
      inherit system;
      overlays = [ nix-ros-overlay.overlays.default self.overlays.default ];
    }));
  in {
    overlays.default = import ./overlay.nix nix-ros-overlay.lib;

    legacyPackages = forAllSystems (pkgs: {
      inherit (pkgs.rosPackages) jazzy banana mango;
    });

    packages = forAllSystems (pkgs: let
      update-overlay = nix-ros-overlay.packages.${pkgs.system}.update-overlay;
      mangoRosdistro = pkgs.runCommand "rosdistro-mango" { } ''
        cp -r ${rosdistro} $out
        chmod -R u+w $out
        cp ${./rosdistro/index-v4.yaml} $out/index-v4.yaml
        cp -r ${./rosdistro/mango} $out/mango
      '';
    in {
      inherit (pkgs.rosPackages.banana) angles ackermann-msgs example-interfaces;
      env = pkgs.rosPackages.banana.buildEnv {
        paths = with pkgs.rosPackages.banana; [ angles ackermann-msgs example-interfaces ];
      };

      mango-ros-base = pkgs.rosPackages.mango.ros-base;

      # Regenerates banana's packages, from the rosdistro nix-ros-overlay pins.
      inherit update-overlay;

      # Regenerates mango, from rosdistro/. update-overlay keys its package.xml
      # cache on `rev`, so it follows the contents of rosdistro/ as well as
      # the upstream tree.
      update-mango = update-overlay.override {
        rosdistro = mangoRosdistro // {
          inherit (rosdistro) lastModifiedDate;
          rev = "${rosdistro.rev}-${builtins.hashString "sha256"
            (builtins.readFile ./rosdistro/index-v4.yaml
              + builtins.readFile ./rosdistro/mango/distribution.yaml)}";
        };
      };
    });
  };
}
