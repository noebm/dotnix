{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kinect-firmware-utils = {
      url = "github:noebm/kinect-firmware-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    nixvim,
    kinect-firmware-utils,
    sops-nix,
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

        home-manager.users.${user} = import ./home.nix {
          inherit pkgs nixvim config;
        };
      })
    ];
    secretConfig = [
      sops-nix.nixosModules.sops
      ({config, ...}: {
        sops.defaultSopsFile = ./secrets/user.yaml;
        sops.defaultSopsFormat = "yaml";

        sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

        sops.secrets."git/email".owner = user;
        sops.secrets."git/full_name".owner = user;

        sops.templates."git_secrets" = {
          content = ''
            [user]
              name = ${config.sops.placeholder."git/full_name"}
              email = ${config.sops.placeholder."git/email"}
          '';
          owner = user;
        };
      })
    ];
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self inputs system hostname;
        userConfig = {
          inherit user;
        };
      };
      modules =
        homeConfig
        ++ secretConfig
        ++ [
          nixos-hardware.nixosModules.common-pc-ssd
          kinect-firmware-utils.nixosModules.${system}.default
          ./hosts/${hostname}
          ./modules/dirty.nix
        ];
    };
    packages.${system}.nvim = let
      nixvim' = nixvim.legacyPackages.${system};
      config = import ./nvim.nix;
    in
      nixvim'.makeNixvim config;
  };
}
