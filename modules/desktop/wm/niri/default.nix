{ inputs, ... }: {
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.niri = {
    nixos = {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri.enable = true;
    };
  };
}
