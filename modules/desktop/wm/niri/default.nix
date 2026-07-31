{ inputs, ... }: {
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.niri = {
    provides.to-hosts.nixos = { pkgs, ... }: {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri.enable = true;

      environment.systemPackages = [ pkgs.xwayland-satellite ];
    };
  };
}
