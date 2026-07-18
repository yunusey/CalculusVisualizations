{
  description = "Reproducible Linux and WASM builds for Calculus Visualizations (Godot 4.3)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;

        # Project targets Godot 4.3 (see project.godot config/features).
        godot = pkgs.godot_4_3;

        pname = "calculus-visualizations";

        src = lib.fileset.toSource {
          root = ./.;
          fileset = lib.fileset.unions [
            ./project.godot
            ./export_presets.cfg
            ./icon.svg
            ./icon.svg.import
            ./MainMenu.gd
            ./MainMenu.tscn
            ./AboutPage
            ./Assets
            ./Axes
            ./DiskMethod
            ./GimbalCamera
            ./ShapeCrossMethod
          ];
        };

        # Shared setup: writable HOME + export templates linked where Godot expects them.
        mkGodotExport = {
          pname,
          preset,
          exportPath,
          templates,
          install,
        }:
          pkgs.stdenv.mkDerivation {
            inherit pname src;
            version = self.shortRev or self.dirtyShortRev or "dev";

            strictDeps = true;

            nativeBuildInputs = [
              godot
              pkgs.writableTmpDirAsHomeHook
            ];

            buildPhase = ''
              runHook preBuild

              mkdir -p "$HOME/.local/share/godot"
              ln -s ${templates}/share/godot/export_templates \
                "$HOME/.local/share/godot/export_templates"

              mkdir -p "$(dirname ${lib.escapeShellArg exportPath})"
              godot4 --headless --path "$PWD" --export-release ${lib.escapeShellArg preset} \
                ${lib.escapeShellArg exportPath}

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              ${install}
              runHook postInstall
            '';

            meta = {
              description = "Calculus Visualizations — solids of revolution and cross sections";
              homepage = "https://github.com/yunusey/CalculusVisualizations";
              license = lib.licenses.mit;
              platforms = lib.platforms.linux;
            };
          };

        linux = mkGodotExport {
          pname = "${pname}-linux";
          preset = "Linux";
          exportPath = "build/linux/${pname}.x86_64";
          # Source-built template is linked correctly for NixOS / nix run.
          templates = godot.export-template;
          install = ''
            mkdir -p "$out/libexec" "$out/bin"
            # Godot names the PCK after the basename without the arch suffix.
            install -Dm755 build/linux/${pname}.x86_64 "$out/libexec/${pname}"
            install -Dm644 build/linux/${pname}.pck "$out/libexec/${pname}.pck"
            ln -s "$out/libexec/${pname}" "$out/bin/${pname}"
          '';
        };

        # Official Godot Linux template — portable artifact for non-Nix systems.
        linuxPortable =
          (mkGodotExport {
            pname = "${pname}-linux-portable";
            preset = "Linux";
            exportPath = "build/linux/${pname}.x86_64";
            templates = godot.export-templates-bin;
            install = ''
              mkdir -p "$out"
              install -Dm755 build/linux/${pname}.x86_64 "$out/${pname}.x86_64"
              install -Dm644 build/linux/${pname}.pck "$out/${pname}.pck"
            '';
          }).overrideAttrs
          (_: {
            # Keep the upstream dynamic linker / RPATH for generic distros.
            dontStrip = true;
            dontPatchELF = true;
          });

        webHeaders = pkgs.writeText "${pname}-headers" ''
          /*
            Cross-Origin-Opener-Policy: same-origin
            Cross-Origin-Embedder-Policy: require-corp
            Access-Control-Allow-Origin: *
        '';

        web = mkGodotExport {
          pname = "${pname}-web";
          preset = "Web";
          exportPath = "build/web/index.html";
          # Official templates include the WebAssembly/HTML5 targets.
          templates = godot.export-templates-bin;
          install = ''
            mkdir -p "$out"
            cp -a build/web/. "$out/"
            # COOP/COEP headers for hosts that honor them (e.g. Cloudflare/Netlify Pages).
            # GitHub Pages ignores this file, which is fine since the build does not require them.
            cp ${webHeaders} "$out/_headers"
          '';
        };
      in {
        packages = {
          inherit linux linuxPortable web;
          default = linux;
          # Alias for nix build .#linux-portable
          linux-portable = linuxPortable;
          all = pkgs.symlinkJoin {
            name = "${pname}-all";
            paths = [
              linux
              (pkgs.runCommand "${pname}-web-share" {} ''
                mkdir -p "$out/share/${pname}"
                ln -s ${web} "$out/share/${pname}/web"
              '')
            ];
          };
        };

        apps = {
          default = {
            type = "app";
            program = "${linux}/bin/${pname}";
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            godot
            godot.export-templates-bin
          ];
          shellHook = ''
            # Make export templates available to the editor / CLI exports.
            mkdir -p "$HOME/.local/share/godot"
            templates="$HOME/.local/share/godot/export_templates"
            version_dir="${lib.versions.majorMinor godot.version}.stable"
            if [ ! -e "$templates/$version_dir" ]; then
              mkdir -p "$templates"
              ln -sfn ${godot.export-templates-bin}/share/godot/export_templates/"$version_dir" \
                "$templates/$version_dir"
            fi
          '';
        };
      }
    );
}
