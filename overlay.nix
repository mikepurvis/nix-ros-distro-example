# The nixpkgs overlay this repo contributes, given nix-ros-overlay's flake
# output `lib`. Goes after nix-ros-overlay's own overlay.
rosLib: final: prev: prev.lib.composeManyExtensions [
  # banana: our packages on top of the bundled jazzy, under a name of our own,
  # so rosPackages.jazzy stays upstream's and both can be built side by side.
  # Packages we regenerate replace upstream's and still get its fixups.
  (rosLib.rosDistroOverlay {
    name = "banana";
    distro = "jazzy";
    version = 2;
    generated = [ (rosLib.bundledGenerated "jazzy") ./distros/jazzy ];
  })

  # mango: a distro of its own, generated from rosdistro/ (a snapshot of
  # rolling) with nothing underneath it. It still takes rolling's fixups,
  # which carry the vendor package hashes for these versions.
  (rosLib.rosDistroOverlay {
    distro = "mango";
    overridesFrom = "rolling";
    version = 2;
    generated = ./distros/mango;
  })

  # The lightest touch: patch packages into the bundled distro in place.
  # (rosLib.extendRosDistro "jazzy" ./distros/jazzy)
] final prev
