{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zwift = {
      url = "github:netbrain/zwift";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dotnvim = {
      url = "github:noebm/dotnvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    kinect-firmware-utils = {
      url = "github:noebm/kinect-firmware-utils";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    hostname = "nixos";
    system = "x86_64-linux";
    user = "noebm";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    homeConfig = [
      home-manager.nixosModules.home-manager
      # sops-nix.homeManagerModules.sops
      ({config, ...}: {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "hm-backup";

        home-manager.users.${user} = import ./home.nix {
          inherit pkgs config inputs system;
        };
      })
    ];
    secretConfig = [
      inputs.sops-nix.nixosModules.sops
      ./modules/nixos/sops.nix
    ];
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self inputs system hostname user;
      };
      modules =
        homeConfig
        ++ secretConfig
        ++ [
          ./hosts/${hostname}
          ./modules/nixos/dirty.nix
        ];
    };
  };
}
