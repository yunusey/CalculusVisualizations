# Calculus Visualizations

[Calculus Visualizations](https://github.com/yunusey/CalculusVisualizations) is a tool for visualizing calculus concepts such as solids of revolution and solids of cross sections.

## Overview

The project is built with Godot 4.3. It ships two interactive 3D scenes: the disk/washer method for solids of revolution, and solids with known cross sections. Functions are entered as [Godot expressions](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html) and evaluated at runtime, so the geometry updates live as you change parameters.

The Web build runs on the Compatibility (WebGL2) renderer, since that is the only renderer available for Godot web exports.

## Web Version

The tool runs in the browser at [yunusey.github.io/CalculusVisualizations](https://yunusey.github.io/CalculusVisualizations/). The desktop build behaves identically and runs faster locally.

## Building

Builds are reproducible through Nix (see [flake.nix](flake.nix)):

- `nix build .#web` produces the WebAssembly/HTML export.
- `nix build .#linux` and `nix build .#linux-portable` produce Linux binaries (the portable variant keeps the upstream dynamic linker for generic distros).
- `nix run` launches the Linux build.
- `nix develop` opens a shell with Godot and the export templates already wired up.

Without Nix, clone the repository and open it in Godot 4.3:

```bash
git clone https://github.com/yunusey/CalculusVisualizations.git
```

## Continuous Integration

[.github/workflows/godot-ci.yml](.github/workflows/godot-ci.yml) builds the Web and Linux exports with Nix on every push to `main` and deploys the Web build to GitHub Pages. It uses DeterminateSystems' `nix-installer-action` and `magic-nix-cache-action`, `actions/upload-artifact` for the build outputs, and `actions/upload-pages-artifact` with `actions/deploy-pages` for publishing.

## User Guide

* To move around, use the `WASD` keys. The camera always rotates *around the origin*.

* To zoom in and out, use `Mouse Wheel Up` and `Mouse Wheel Down`. The value is clamped when you zoom in or out too far, so you do not lose track.

* Press `H` to toggle the menu if it takes up too much space.

* Press `F` to toggle full-screen mode.

* Equations use [Godot expressions](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html), not standard mathematical notation (for example, `x^2` does not work). Some examples:
    - $x^2$ = `x * x` = `pow(x, 2)`
    - $ln(x)$ = `log(x)`
    - $\sqrt{x}$ = `sqrt(x)`
    - $3x$ = `3 * x`

## Parameters

### Disk & Washer Method
- **# Rectangles**: Changes the number of rectangles for a more or less precise version of the shape.
- **Shape Rot.**: Changes the rotation of the *entire shape*.
- **Disk Rot.**: Changes the rotation of the *disk*.
- **Shape Trans.**: Changes the transparency of the *entire shape* (useful to show the disk in the shape).
- **Disk Trans.**: Changes the transparency of the *disk*.
- **Coloring**: `Distinct` makes the disk red and the rest of the shape blue (so that you can *distinct* the disk from the rest of the shape). `Gradient` gives nice coloring to the rectangles for better visuals.
- $f(x)$: Changes the *upper function*.
- $g(x)$: Changes the *lower function* (by default, it is `0` so that you can visualize the disk method).
- $a$ and $b$: Represents the domain of the functions: $[a, b]$.

### Shape Cross-Sections
- **Shapes**: Change the shape of the cross-sections (available options are `Squares`, `Equilateral Triangles`, `Isosceles Right Triangles`, and `Semi Circles`).
- **# Shapes**: Changes the number of disks/cross-sections in the shape.
- **Shape Trans.**: Changes the transparency of the *entire shape* (useful to show the disk in the shape).
- **Disk Trans.**: Changes the transparency of the *disk*.
- **Coloring**: `Distinct` makes the disk red and the rest of the shape blue (so that you can *distinct* the disk from the rest of the shape). `Gradient` gives nice coloring to the rectangles for better visuals.
- $f(x)$: Changes the function.
- $a$ and $b$: Represents the domain of the function: $[a, b]$.

## References & Thanks
- [Godot Game Engine](https://godotengine.org) for *everything*.
- [DeterminateSystems' nix-installer-action](https://github.com/DeterminateSystems/nix-installer-action) for installing Nix in CI.
