{ inputs, ... }:

{
  wayland.windowManager.hyprland = { 
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [ 
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ]; # Нужно лм это ставить через Hyprland?

      input = {
        kb_layout = "us,ru";
	      kb_options = "grp:caps_toggle";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";

        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
    
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = "yes";e

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = "off";
      };

      misc = {
        force_default_wallpaper = -1;
      };

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "L_Alt, Space, exec, $menu"
        "$mainMod, P, pseudo," 
        "$mainMod, J, togglesplit,"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
	      "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ]
      ++ (
        builtins.concatLists (
          builtins.genList (
            x: let
            ws = let
            c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
            in [
              "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
              "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
        10)
      );
      bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
      ];
    };
    #plugins = [
    #  inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces    Вернуть когда починят
    #];
  };
}
