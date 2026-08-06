# Driver proprietário NVIDIA com PRIME sync: a RTX 4050 renderiza tudo o
# tempo todo (sem alternância hybrid/offload). Escolhido porque a Nitro
# fica majoritariamente na tomada — troca simplicidade e desempenho
# máximo por um consumo de bateria maior quando desplugada. Ajuste
# nvidiaBusId/intelBusId com `lspci | grep -E "VGA|3D"` na máquina real
# antes do primeiro rebuild.
{ config, ... }: {
  den.aspects.nvidia = {
    nixos = {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
          sync.enable = true;
          nvidiaBusId = "PCI:1:0:0"; # CHANGEME — confirmar com lspci
          intelBusId = "PCI:0:2:0"; # CHANGEME — confirmar com lspci
        };
      };
    };
  };
}
