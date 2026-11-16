# https://docs.noctalia.dev/umbriel/configuration/
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings = {
        include = {
          files = [ ];
          # Tema gerado pelo Noctalia (Settings → Templates → Compositors → Umbriel);
          # substituiria as cores do Stylix em appearance.nix.
          optional.files = [ ];
        };

        general = {
          autostart = [ ]; # o Noctalia sobe pelo systemd (graphical-session.target)
          mod_key = "Super";
          xwayland = true; # Xwayland embutido; o niri usa xwayland-satellite
          xwayland_native_resolution = false;
          xwayland_xsettings = true;
          xwayland_primary_output = "";
          nvidia_sync_workaround = true;
          show_cheatsheet = false; # niri: hotkey-overlay.skip-at-startup
          focus_on_activate = false;
          attach_modal_dialogs = true;
          honor_restored_maximize = false;
        };

        # Comandos ao fechar e abrir a tampa do notebook.
        # events = {
        #   lid_close = "umbriel msg output-disable eDP-1";
        #   lid_open = "umbriel msg output-enable eDP-1";
        # };

        screencast.disable_dynamic_confirmation = false;

        # GPUs que o Umbriel não deve abrir (ex.: passthrough para VM).
        # drm = {
        #   ignored_pci_addresses = [ "0000:01:00.0" ];
        #   ignored_devices = [ "/dev/dri/by-path/pci-0000:01:00.0-card" ];
        # };

        # Protocolos extras para apps em sandbox (Flatpak).
        # security_context_rule = [
        #   {
        #     match = {
        #       sandbox_engine = "org\\.flatpak";
        #       app_id = "org\\.example\\.ClipboardManager";
        #     };
        #     allow_globals = [
        #       "ext_data_control_manager_v1"
        #       "zwlr_data_control_manager_v1"
        #     ];
        #   }
        # ];
      };
    };
  };
}
