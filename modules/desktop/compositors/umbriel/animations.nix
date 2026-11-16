# https://docs.noctalia.dev/umbriel/animation/
# Springs do niri viram "spring:<damping-ratio>,<stiffness>"; os easings viram
# curvas Bézier (ease-out-quad e ease-out-cubic). Sem equivalente:
# horizontal-view-movement (a rolagem segue windows_move),
# config-notification-open-close e screenshot-ui-open.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.animation = {
        enabled = true;
        duration_ms = 250;
        curve = "easeout";

        # Curvas nomeadas, usadas como `curve = "<nome>"`.
        # beziers.myBezier = [ 0.05 0.9 0.1 1.05 ];
        # springs.myBounce = { damping = 0.5; stiffness = 200; };

        windows_in = {
          enabled = true;
          duration_ms = 200;
          curve = "0.25,0.46,0.45,0.94";
          style = "popin"; # "popin", "zoom", "slide", "fade" ou "none"
          scale = 0.5;
        };

        windows_out = {
          enabled = true;
          duration_ms = 200;
          curve = "0.215,0.61,0.355,1.0";
          style = "popin"; # "fade", "slide", "popin" ou "zoom"
          scale = 0.8;
        };

        windows_move = {
          enabled = true;
          curve = "spring:1.0,800";
        };

        windows_resize = {
          enabled = true;
          curve = "spring:1.0,1000";
          wait_for_redraw = false;
        };

        windows_opacity = {
          enabled = true;
          curve = "spring:1,900";
        };

        workspaces = {
          enabled = true;
          curve = "spring:1.0,1000";
          style = "slide"; # "reveal" requer o efeito workspace_wipe (effects.nix)
        };

        overview = {
          enabled = true;
          curve = "spring:1.0,900";
          workspace_curve = "spring:1,1000";
        };

        scratchpad = {
          enabled = true;
          curve = "spring:1,800";
          dim = 0.8;
          blur = false;
        };

        dialogs = {
          enabled = true;
          dim = 0.3;
        };

        border = {
          enabled = true;
          curve = "spring:1,900";
        };

        dim_unfocused = {
          enabled = false;
          dim = 0.0;
        };

        # O Noctalia anima as próprias camadas; ligar isto causa falhas visuais.
        layers.enabled = false;

        # Janela "gelatinosa" ao arrastar.
        windows_drag = {
          physics = false;
          stiffness = 36.0;
          damping = 6.5;
          coupling = 100.0;
          pointer_response = 2.0;
          max_displacement_px = 200.0;
          settle_after_pause_s = 0.25;
        };
      };
    };
  };
}
