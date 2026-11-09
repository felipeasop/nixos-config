{
  den.aspects.solaar = {
    nixos = { lib, pkgs, ... }: {
      programs.solaar = {
        enable = true;
        userService = {
          enable = true;
          window = "hide";
        };
      };

      # O pacote atual não inclui o typelib opcional do libnotify no wrapper.
      systemd.user.services.solaar.environment = {
        GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" [ pkgs.libnotify ];
        LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.libnotify ];
      };
    };
  };
}
