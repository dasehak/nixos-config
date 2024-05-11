{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-blender-3-6-5.url = "github:nixos/nixpkgs/a71323f68d4377d12c04a5410e214495ec598d4c";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs"; 
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces/main";
      inputs.hyprland.follows = "hyprland";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self, 
    nixpkgs,
    nixpkgs-blender-3-6-5,
    split-monitor-workspaces,
    home-manager,
    chaotic,
    stylix,
    nixvim,
    nur,
    ...
  } @ inputs: {
    nixosConfigurations.nyax =
      let
        system = "x86_64-linux";

        de = "plasma"; # см. configuration.nix

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dasehak = import ./users/dasehak/home.nix;
  	    home-manager.extraSpecialArgs = specialArgs;
	    nixpkgs.overlays = [
              nur.overlay 
	    ];
          }
	  chaotic.nixosModules.default
#	  nur.nixosModules.nur
        ] ++ (if de == "wayland" || de == "xorg" then stylix.nixosModules.stylix else []);
      in
      nixpkgs.lib.nixosSystem { inherit system modules specialArgs; };
  }; 
}

