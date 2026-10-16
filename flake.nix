{
  description = "ROS packages generated outside nix-ros-overlay, built with its machinery";

  inputs = {
    nix-ros-overlay.url = "github:mikepurvis/nix-ros-overlay/mkrosdistro-develop-AN2ATG0";
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
      # update-overlay builds a package.xml cache for every distro in its
      # rosdistro's index, and one broken distro stops it. So each distro here
      # gets a copy of the pinned rosdistro tree, keeping rosdep and the rest,
      # with an index of just what it needs. `script` edits $out. The cache is
      # keyed on `rev`, which follows `script` and so the files it copies in.
      rosdistroFor = name: script: pkgs.runCommand "rosdistro-${name}"
        { nativeBuildInputs = [ pkgs.yq-go ]; } ''
          cp -r ${rosdistro} $out
          chmod -R u+w $out
          ${script}
        '' // {
          inherit (rosdistro) lastModifiedDate;
          rev = "${rosdistro.rev}-${builtins.hashString "sha256" script}";
        };
      updateOverlayFor = name: script:
        nix-ros-overlay.packages.${pkgs.system}.update-overlay.override {
          rosdistro = rosdistroFor name script;
        };
    in {
      inherit (pkgs.rosPackages.banana) angles ackermann-msgs example-interfaces;
      env = pkgs.rosPackages.banana.buildEnv {
        paths = with pkgs.rosPackages.banana; [ angles ackermann-msgs example-interfaces ];
      };

      mango-ros-base = pkgs.rosPackages.mango.ros-base;

      # Regenerates banana's packages, from the jazzy in the rosdistro
      # nix-ros-overlay pins: `nix run .#update-banana -- <ros package>...`.
      # superflore writes under
      # distros/<ros distro>, jazzy here, and commits to the repo it is given,
      # so it runs in a scratch repo and the expressions are copied across.
      update-banana = pkgs.writeShellApplication {
        name = "update-banana";
        runtimeInputs = [
          (updateOverlayFor "jazzy" ''
            yq -i '.distributions |= with_entries(select(.key == "jazzy"))' $out/index-v4.yaml
          '')
          pkgs.git
        ];
        text = ''
          scratch=$(mktemp -d)
          trap 'rm -rf "$scratch"' EXIT
          git -C "$scratch" init -q
          git -C "$scratch" commit -q --allow-empty -m scratch
          update-overlay --dry-run --no-branch --output-repository-path "$scratch" \
            --tar-archive-dir "$PWD/.tar" --ros-distro jazzy --only "$@"
          mkdir -p distros/banana
          cp -r "$scratch"/distros/jazzy/. distros/banana/
        '';
      };

      # Regenerates mango, from the index and distribution file in rosdistro/.
      update-mango = updateOverlayFor "mango" ''
        cp ${./rosdistro/index-v4.yaml} $out/index-v4.yaml
        cp -r ${./rosdistro/mango} $out/mango
      '';
    });
  };
}
