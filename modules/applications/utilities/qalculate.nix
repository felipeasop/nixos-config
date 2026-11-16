{
  den.aspects.qalculate = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        qalculate-qt
        libqalculate
      ];
    };
  };
}
