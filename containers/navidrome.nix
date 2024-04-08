{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers."navidrome" = {
    autoStart = true;
    image = "deluan/navidrome:latest";
    ports = [ "4533:4533" ];
    environment = {
      ND_SCANSCHEDULE = "1h";
      ND_LOGLEVEL = "info";  
      ND_SESSIONTIMEOUT = "24h";
      ND_BASEURL = "";
    };
    volumes = [
      "/media/containers/navidrome/data:/data"
      "/media/containers/navidrome/music:/music:ro"
    ];
  };
}
