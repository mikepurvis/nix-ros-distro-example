# nix-ros-distro-example

A repo that keeps its own generated ROS package expressions and builds them
with [nix-ros-overlay][overlay]'s machinery, without forking it. It pairs with
branch [`mkrosdistro-AN2ATG0`][branch] of the overlay; see
`docs/external-distros.md` there for the user-facing API.

[overlay]: https://github.com/lopsided98/nix-ros-overlay
[branch]: https://github.com/mikepurvis/nix-ros-overlay/tree/mkrosdistro-AN2ATG0

## What's here

- `distros/jazzy/{angles,ackermann-msgs,example-interfaces}` were written by
  the overlay's `update-overlay`, run against this repo:

  ```sh
  nix build github:mikepurvis/nix-ros-overlay/mkrosdistro-AN2ATG0#update-overlay
  ./result/bin/update-overlay --dry-run --no-branch --output-repository-path . \
    --tar-archive-dir .tar --ros-distro jazzy --only angles ackermann_msgs example_interfaces
  ```

  The output matches the overlay's own expressions byte for byte.
- `overlay.nix` adds `rosPackages.example-jazzy` (bundled jazzy plus these)
  and `rosPackages.example-standalone` (these alone).
- `flake.nix` and `default.nix` are the flake and non-flake entry points; the
  non-flake one takes its pin from `flake.lock`.

```sh
nix build .#env                      # the three packages in a ros-env
nix-build -A rosPackages.example-jazzy.angles
```

`rosPackages.example-jazzy.<pkg>.drvPath` equals `rosPackages.jazzy.<pkg>.drvPath`
for every package checked, ours and upstream's, so a repo building this way
shares the binary cache with the overlay.

## What is coupled today (upstream develop / dev-out)

1. `distros/distro-overlay.nix` imports `./${distro}/generated.nix` and
   `./${distro}/overrides.nix` by relative path. `distro` is the only input.
2. `distro` is used for six things at once: those two paths, the
   `rosPackages.${distro}` attribute that splicing looks up for
   cross-compilation, `ROS_DISTRO` passed to `buildRosPackage`, the Qt 5/6
   choice, and the jazzy-only dev-output split. A distro named anything other
   than an upstream one gets none of the fixups, and a second copy of jazzy
   under another name splices against the wrong set.
3. `rosPackages.mkRosDistroOverlay` exists but takes `{ version, distro }`
   only and has to be called as `mkRosDistroOverlay args self super`.
4. The bundled fixups (`overrides`, `ros2-overlay.nix`, `qt*-overlay.nix`,
   `<distro>/overrides.nix`) reference `rosSuper.<pkg>` for hundreds of
   packages. Applied to a smaller set they leave attributes that throw when
   evaluated, which breaks anything that walks the scope.
5. The generator is less coupled than it looks. superflore writes under
   `distros/<distro>/` in any git repo given by `--output-repository-path`, and
   takes its index from `ROSDISTRO_INDEX_URL`. The gaps: `--only` writes no
   `generated.nix`; `update-overlay` is a flake-only output and its
   `rosdistro` argument must carry `rev`/`lastModifiedDate`; pnames are always
   `ros-<distro>-<pkg>`.

## What the branch changes

- `distro-overlay.nix` takes `{ distro, version, name ? distro, generated ?
  bundled, upstreamOverrides ? true, overrides ? [ ] }`. `name` is only the
  attribute and splice key; `distro` keeps its behavioural meaning.
  `generated` takes an overlay, a file, a directory of `<pkg>/default.nix`
  (so superflore's `--only` output needs no `generated.nix`), or a list.
- Against a set that isn't the bundled one, bundled fixups are filtered to
  packages that exist, plus additions the bundled set doesn't define (aliases
  and packages taken from nixpkgs). This uses only attribute names, so it
  doesn't force any package.
- `rosPackages.mkRosDistro args` returns the scope; the bundled distros use it.
  `mkRosDistroOverlay` is kept for compatibility.
- `lib/distro-overlays.nix` (flake output `lib`) has pkgs-free nixpkgs
  overlays: `rosDistroOverlay`, `extendRosDistro`, and `bundledGenerated` and
  `generatedOverlay` helpers. It is a plain file, so non-flake users import it
  directly.
- All bundled distros evaluate to the same drvPaths as before (checked on
  jazzy, humble, kilted and rolling, including `desktop`).

## What upstream would likely accept

- The `distro-overlay.nix` argument split and `mkRosDistro` look like a safe
  sell. They are additive, change no hashes, and fix the existing
  `mkRosDistroOverlay` awkwardness. `nix-ros-overlay`'s NixOS module already
  calls `overrideScope` on a distro, so they support customisation in principle.
- `lib/distro-overlays.nix` works without flakes, which matters given
  upstream's stance; the flake `lib` output just re-exports it. A
  pkgs-independent flake `lib` is a common convention.
- The pruning of dangling fixups is the part to expect questions on: the
  maintainer may prefer `upstreamOverrides = false` plus documentation over
  filtering. Bundled jazzy still carries one dangling fixup of its own,
  `gazebo-ros`, which is ROS 1 only. It is visible in `example-standalone`.
- A superflore change to write `generated.nix` with `--only`, or an output
  path flag, is unnecessary given directory support. Making `update-overlay`
  reachable without flakes (for example `pkgs.rosPackages.update-overlay`, with
  `rosdistro` defaulting to a `fetchTarball` from `flake.lock`) would be a
  small follow-up if a non-flake user asks.
