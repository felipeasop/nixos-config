{ inputs, ... }: {
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.niri = {
    provides.to-hosts.nixos = { pkgs, lib, ... }: {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri.enable = true;

      # Stable niri (v25.08) hard-requires libdisplay-info 0.2.0 exactly
      # (`assert libdisplay-info_0_2.version == "0.2.0"` in niri-flake),
      # but nixpkgs has since bumped/removed that attribute. Build 0.2.0
      # straight from upstream so this doesn't depend on any nixpkgs
      # revision (ours or niri-flake's) still happening to carry it.
      # https://github.com/sodiboo/niri-flake
      # https://gitlab.freedesktop.org/emersion/libdisplay-info
      nixpkgs.overlays = [
        (final: prev: {
          libdisplay-info_0_2 = prev.libdisplay-info.overrideAttrs (old: rec {
            pname = "libdisplay-info";
            version = "0.2.0";
            src = prev.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "emersion";
              repo = "libdisplay-info";
              rev = version;
              hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
            };
          });
        })
      ];

      environment.systemPackages = [ pkgs.xwayland-satellite ];
    };
  };
}
