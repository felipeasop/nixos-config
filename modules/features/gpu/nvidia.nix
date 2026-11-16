{
  den.aspects.nvidia = {
    nixos = {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        graphics.enable = true;

        nvidia = {
          # Módulo aberto: recomendado pela NVIDIA da Turing (RTX 20) em diante.
          open = true;
          # Preserva a VRAM ao suspender (serviços nvidia-suspend/resume).
          powerManagement.enable = true;
          # Fora de todo cache (compilaria localmente); configurações via nvidia-smi.
          nvidiaSettings = false;
        };
      };
    };
  };
}
