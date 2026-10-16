# Non-flake entry point: nixpkgs with nix-ros-overlay and this repo's
# overlay applied, both pinned by flake.lock.
let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  rosOverlayLock = lock.nodes.nix-ros-overlay.locked;
  lockedRosOverlay = builtins.fetchTarball {
    url = "https://github.com/${rosOverlayLock.owner}/${rosOverlayLock.repo}/archive/${rosOverlayLock.rev}.tar.gz";
    sha256 = rosOverlayLock.narHash;
  };
in
{ nix-ros-overlay ? lockedRosOverlay, overlays ? [ ], ... }@args:
import nix-ros-overlay (removeAttrs args [ "nix-ros-overlay" ] // {
  overlays = [
    (import ./overlay.nix (import "${nix-ros-overlay}/lib/distro-overlays.nix"))
  ] ++ overlays;
})
