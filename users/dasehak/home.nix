{ inputs, config, pkgs, lib, ... }:
let
  de = "plasma"; # Вынести в файл, дабы не прописывать во множестве файлов однл и то же
  additionalPackages = (if de == "wayland" then import ./desktop-variants/wayland.nix { inherit pkgs; }
                        else if de == "xorg" then import ./desktop-variants/xorg.nix { inherit pkgs; }
                        else if de == "plasma" then import ./desktop-variants/plasma.nix { inherit pkgs; }
                        else []);
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ] ++ (if de == "wayland" then [
    ./hyprland.nix
    ./waybar.nix 
  ]
  else []) ++ (if de == "wayland" /*|| de == "xorg"*/ then [ ./stylix.nix ] else []);

  home = { 
    username = "dasehak";
    homeDirectory = "/home/dasehak";
    stateVersion = "24.05";
    packages = with pkgs; [
      bandwhich
      inputs.nixpkgs-blender-3-6-5.legacyPackages.${pkgs.system}.blender-hip
      inputs.ayugram-desktop.packages.${pkgs.system}.default
      inputs.pollymc.packages.${pkgs.system}.pollymc #-unwrapped
      cinny-desktop
      dconf # Убрать и проверить что будет
      clang
      dust
      eza
      jetbrains.clion
      nextcloud-client
      hyperfine
      pinentry
      tgpt
      haruna
      logseq
      glaxnimate
      ffmpeg
      # ungoogled-chromium
      onlyoffice-bin
      tree
      vesktop
      btop
      fastfetch
      mmex
      obsidian
      bun
      keepassxc
      strawberry
      tor-browser-bundle-bin
      krita
      kdenlive
      nicotine-plus
      mangohud
      killall
      poetry
      pavucontrol
      qbittorrent
      wget
      git
      mesa-demos
      docker-compose # Убрать и посмотреть что будет
      winetricks
      obs-studio
      openjdk8
      unrar
      unzip
      p7zip
      mumble
      lldb
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      gparted
    ] ++ additionalPackages.specificPackages;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  services.arrpc.enable = true;

  qt = {
    platformTheme = if de == "wayland" || de == "xorg" then "qt5ct" else "kde";
  };

  programs = {
    firefox.enable = true;
    fish.enable = true;
    home-manager.enable = true;
    nixvim = {
      enable = true;
      colorschemes.catppuccin.enable = true;
      plugins = {
        lualine.enable = true;
        lsp = {
          enable = true;
          servers = {
            lua-ls.enable = true;
            rust-analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            clangd.enable = true;
          };
        };
	    telescope.enable = true;
      };
      opts = {
        number = true;
        shiftwidth = 4;
      };
      globals.mapleader = ",";
    };
    vscode = {
      enable = de == "plasma";
    };
    yazi = {
      enable = de == "wayland" || de == "xorg";
      enableFishIntegration = true;
      settings = {
        manager = {
         show_hidden = true;
         sort_by = "natural";
         sort_dir_first = true;
        };
      };
    };
    rofi.enable = de == "xorg";
  };
}

