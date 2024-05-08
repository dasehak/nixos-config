{ inputs, config, lib, pkgs, ... }:
let
  de = "plasma"; # Вынести в отдельный файл дабы не прописывать несколько раз в разных файлх
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  chaotic.nyx.cache.enable = true;

  nix.settings = { 
    experimental-features = "nix-command flakes";
    substituters = [
      "https://nix-gaming.cachix.org"
    ] ++ (if de == "wayland" then [ "https://hyprland.cachix.org" ] else []);
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ] ++ (if de == "wayland" then [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ] else []);
  };

  networking = { 
    hostName = "nyax";
    networkmanager.enable = true; 
  }; 

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    adb.enable = true;
    hyprland = {
      enable = de == "wayland";
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    fish.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    virt-manager.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
      enableSSHSupport = true;
    };
    slock.enable = de == "xorg";
  };
  
  zramSwap = {
    enable = true;
    memoryPercent = 100; 
  };

  security = {
    rtkit.enable = true;
    sudo.enable = false;
    sudo-rs.enable = true;
  };

  services = { 
    syncthing = {
      enable = true;
      user = "dasehak";
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      libinput.enable = true;
      displayManager = {
 	sddm = {
	  wayland.enable = de == "plasma";
	  enable = de == "plasma";
	};
	lightdm.enable = false;
	startx.enable = de == "xorg";
	defaultSession = (if de == "plasma" then "plasma" else if de == "xorg" then "xterm" else "");
      };
      windowManager.dwm = {
        enable = de == "xorg";
	package = pkgs.dwm.override {
	  conf = ./configs/dwm.h;
	};
      };
    };
    desktopManager.plasma6.enable = de == "plasma";
    openssh = {
      enable = true;
      ports = [ 21543 ];
    };
    tor = {
      enable = true;
      client.enable = true;
      settings = {
        UseBridges = true;
        ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
        Bridge = "obfs4 65.21.57.175:443 88C9749DFE8AD05E8A8D88C3DCD28700D7D2EEF5 cert=I6JiSzR7OLMXI3yqrBkU1uXCnXkrMzTUibdVFT+vwPwcJYF9jo5+KjuvLNrQFv5IMz60bg iat-mode=0";
      };
    };
    avahi = {
      enable = true;
      publish.userServices = true;
    };
    murmur = {
      enable = true;
      openFirewall = true;
      bandwidth = 128000;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    opengl.enable = true;
  };

  users.users.dasehak = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "adbusers"
      "kvm"
    ];
    shell = pkgs.fish;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    # virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };
  };

  environment = { 
    systemPackages = with pkgs; [
      obfs4
      lsof
      bat
      git
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      nerdfonts
      corefonts
      # uw-ttyp0.otb
    ];
    fontconfig.allowBitmaps = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      4533
      5900
      21543
      27015
      47984
      47989
      47990
      48010
      28960
      45762
    ];
    allowedUDPPorts = [
      5900
      27015
      47998
      47999
      48000
      28960
    ];
  };

  system = { 
    stateVersion = "unstable";
  };
}

