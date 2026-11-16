# https://docs.noctalia.dev/umbriel/input/
# Chaves comentadas não têm padrão próprio: omitidas, valem as do libinput.
{
  den.aspects.umbriel = {
    homeManager = { config, ... }: {
      programs.umbriel.settings.input = {
        middle_click_paste = true;
        client_window_drag = true;
        window_drag_toggle = "none"; # "none", "floating" ou "pinned"
        mod_right_double_click = "none"; # "none" ou "maximize"

        keyboard = {
          layout = "br";
          variant = "";
          options = "";
          model = "";
          repeat_rate = 25;
          repeat_delay = 600;
          numlock_toggle = false;
          track_layout = "global";
        };

        touchpad = {
          # enabled = true;
          tap = true;
          # tap_and_drag = false;
          # drag_lock = "sticky";
          # natural_scroll = true;
          # left_handed = false;
          # accel_profile = "adaptive";
          # sensitivity = 0.0;
          # scroll_factor = 1.0;
          # disable_while_typing = true;
          # disable_on_external_mouse = false;
          # scroll_method = "two_finger";
          click_method = "clickfinger";
          # tap_button_map = "left_right_middle";
        };

        mouse = {
          natural_scroll = false;
          # left_handed = false;
          accel_profile = "flat";
          sensitivity = 0.0;
          scroll_wheel_step = 60;
          # scroll_button = "MouseBack";
          # scroll_button_lock = false;
        };

        # Ajustes por dispositivo, pelo nome de `libinput list-devices`.
        # device = [
        #   {
        #     name = "Acme Precision Touchpad";
        #     tap = true;
        #   }
        # ];

        tablet = {
          enabled = true;
          # map_to_output = "DP-1";
          map_to_focused_output = false;
          map_to_focused_window = false;
          left_handed = false;
          # calibration_matrix = [ 1.0 0.0 0.0 0.0 1.0 0.0 ];
        };

        touch = {
          enabled = true;
          # map_to_output = "eDP-1";
        };

        cursor = {
          theme = config.stylix.cursor.name;
          inherit (config.stylix.cursor) size;
          hardware_cursor = true;
          follows_focus = false; # niri: warp-mouse-to-focus
          hide_when_typing = false;
          hide_timeout_ms = 0;
        };

        drag_edge_scroll = {
          enabled = true;
          trigger_zone = 30;
          delay_ms = 100;
          max_speed = 1500.0;
        };

        focus = {
          follows_mouse = false;
          # follows_mouse_max_scroll = 0.5;
          hover_raises = true;
        };
      };
    };
  };
}
