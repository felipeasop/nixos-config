{
  den.aspects.admin-tools = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        htop
        psmisc
        file
        wget
        unzip
      ];
    };
  };
}
