# Calculus Visualizations

_[Calculus Visualizations](https://github.com/yunusey/CalculusVisualizations) is a tool for visualizing calculus concepts such as solids of revolution and solids of cross sections._

## Before Beginning
Probably you are wondering why the project is named something as awkward as **Calculus Visualizations**. Well, I want to remind you one of my favorite quotes:

> There are only two hard things in Computer Science: cache invalidation and naming things.
> - Phil Karlton

Yeah, I couldn't think of a better name...
## Why?
I love [Godot](https://godotengine.com). I needed to create a project that needed to visualize AP Calculus BC concepts for future students at my high school, so I did this!

## Installation
You can check the web version of the tool [here](https://calculus-visualizations.netlify.app/). There is nothing added in the desktop version, but of course, it will work faster locally. I didn't set up GitHub Actions for building the project for desktop, but you can easily open the project locally in Godot following these instructions:

1. Clone the repository or [download the project as ZIP](https://github.com/yunusey/CalculusVisualizations/archive/refs/heads/main.zip) if you don't know how to use GitHub.
```bash
git clone https://github.com/yunusey/CalculusVisualizations.git
```
2. Import the project to Godot.

## User Guide

* To move around, you should use `WASD` keys. The camera always rotates *around the origin*.

* To zoom in and out, you should use `Mouse Wheel Up` and `Mouse Wheel Down`. The value gets clamped down when you zoom in too much or zoom out too much (again, so that you don't lose track).

* If the menu takes too much space and you want to get rid of that, you can use `H` key to toggle the menu.

* To toggle full-screen mode, you should use `F` key.

* When you are entering equations, the standard mathematical format may not work as intended (e.g. `x^2` doesn't work). You should use [Godot's expressions](https://docs.godotengine.org/en/stable/tutorials/scripting/evaluating_expressions.html). Here are several examples you may want to consider:
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
- [MikulasZelinka's Godot Web Export Template](https://github.com/MikulasZelinka/godot-web-export-template) for automatic web builds.
- [Netlify](https://www.netlify.com/) for free hosting.

