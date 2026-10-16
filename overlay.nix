# The nixpkgs overlay this repo contributes, given nix-ros-overlay's flake
# output `lib`. Goes after nix-ros-overlay's own overlay.
rosLib: final: prev: prev.lib.composeManyExtensions [
  # Our packages on top of the bundled jazzy, under a name of our own, so
  # rosPackages.jazzy stays upstream's and both can be built side by side.
  # Packages we regenerate replace upstream's and still get its fixups.
  (rosLib.rosDistroOverlay {
    name = "example-jazzy";
    distro = "jazzy";
    version = 2;
    generated = [ (rosLib.bundledGenerated "jazzy") ./distros/jazzy ];
  })

  # Only our packages: the shape of a distro generated in full from a pinned
  # or private rosdistro. Here it has nothing to depend on, so it evaluates
  # but doesn't build; it shows that fixups for packages it lacks are dropped.
  (rosLib.rosDistroOverlay {
    name = "example-standalone";
    distro = "jazzy";
    version = 2;
    generated = ./distros/jazzy;
  })

  # The lightest touch: patch packages into the bundled distro in place.
  # (rosLib.extendRosDistro "jazzy" ./distros/jazzy)
] final prev
