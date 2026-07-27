{ inputs, ... }: {
  den.aspects.niri = {
    nixos = {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri.enable = true;
    };
  };
}
