{
  den.aspects.nvidia-prime = {
    nixos = {
      hardware.nvidia = {
        # A integrada desenha a sessão; a NVIDIA roda só o que for lançado com
        # `nvidia-offload <app>` e desliga quando ociosa (RTD3).
        prime.offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        powerManagement.finegrained = true;

        # Dynamic Boost (nvidia-powerd): ligar se o notebook suportar.
        # dynamicBoost.enable = true;
      };
    };
  };
}
