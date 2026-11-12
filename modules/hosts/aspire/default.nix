{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "aspire";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      kernel = "latest";
      users.${userName}.classes = [ "homeManager" ];
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        den.batteries.hostname
        systemd-boot
        laptop

        # DEs / WMs
        lxqt
        niri-stack
        firefox
        intel-graphics

        { nixos = import ./_hardware.nix; }
      ];

      nixos = { lib, ... }: {
        hardware.enableRedistributableFirmware = true;

        # Recebe deploys do desktop, rodando lá:
        # nh os switch ~/nixos-config -H aspire --target-host root@aspire.local
        # Root só por chave, e só a do desktop. O primeiro switch é local.
        services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
        users.users.root.openssh.authorizedKeys.keyFiles = [ ../desktop/deploy.pub ];

        swapDevices = [
          {
            device = "/swapfile";
            size = 4096;
          }
        ];
      };
    };
  };
}
