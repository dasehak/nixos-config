{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = { 
    initrd = {
      availableKernelModules = [ "ehci_pci" "aesni_intel" "ahci" "cryptd" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        root = {
          device = "/dev/nvme0n1p3";
          preLVM = true;
        };
        nextcloud = {
          device = "/dev/nvme0n1p4"; # Вместо раздела на диске создать LV в nyax_vg
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "ntfs" ];
  };

  fileSystems = {
    "/" = { 
      device = "/dev/nyax_vg/gentoo";
      fsType = "btrfs";
      options = [ "compress-force=zstd:3" ];
    };

    "/boot" = {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = [ "compress-force=zstd:3" ];
    };

    "/boot/efi" = { 
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/nyax_vg/fedora_home";
      fsType = "btrfs";
      options = [ "compress-force=zstd:3" ]; 
    };

    "/media/containers/nextcloud/data" = {
      device = "/dev/mapper/nextcloud";
      fsType = "ext4";
      options = [ "defaults" ];
    };
  };
  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
