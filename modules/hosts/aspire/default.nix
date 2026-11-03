{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "aspire";
  userName = "flp";
in
{
  den.hosts.${system}.${hostName} = {
    kernel = "latest";
    users.${userName}.classes = [ "homeManager" ];
  };

  den.aspects.${hostName} = {
    includes = with den.aspects; [
      den.provides.hostname
      systemd-boot
      laptop

      # DEs / WMs
      lxqt
      niri-stack
      firefox
      intel-graphics

      { nixos = import ./_hardware.nix; }
    ];

    nixos =
      { lib, pkgs, ... }:
      {
        hardware.enableRedistributableFirmware = true;

        # Conta já existe manualmente (uid 1001) — fixa pra não ambiguar dono de /home/flp.
        users.users.flp.uid = lib.mkDefault 1001;

        # git cru: o aspect git exige secrets, que o aspire não tem ainda.
        environment.systemPackages = [ pkgs.git ];

        swapDevices = [
          {
            device = "/swapfile";
            size = 4096;
          }
        ];

        # nix-settings.nix não usa mkDefault; precisa de mkForce pra sobrepor por host.
        nix.settings = {
          max-jobs = lib.mkForce 1;
          cores = lib.mkForce 2;
        };

        programs.nh.clean.extraArgs = lib.mkForce "--keep-since 14d --keep 2 --nogc-roots --all";
      };

    # host-aspects (flp.nix) só projeta o que está no includes escrito à mão;
    # essential chega via den.schema.host.includes, invisível pra battery.
    provides.to-users.includes = with den.aspects; [ essential ];
  };
}
