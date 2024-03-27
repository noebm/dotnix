{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kinect-audio = {
      url = "/home/noebm/dev/kinect-audio-setup";
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
    home-manager,
    nixvim,
    kinect-audio,
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

        sops.templates."git_secrets".content = ''
          [user]
            name = ${config.sops.placeholder."git/full_name"}
            email = ${config.sops.placeholder."git/email"}
        '';
        sops.templates."git_secrets".owner = user;

        home-manager.users.${user} = import ./home.nix {
          inherit pkgs nixvim config;
        };
      })
    ];
    secretConfig = [
      sops-nix.nixosModules.sops
      {
        sops.defaultSopsFile = ./secrets/user.yaml;
        sops.defaultSopsFormat = "yaml";
        sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
        sops.secrets."git/email".owner = user;
        sops.secrets."git/full_name".owner = user;
      }
    ];
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs system hostname;
        userConfig = {
          inherit user;
        };
      };
      modules =
        homeConfig
        ++ secretConfig
        ++ [
          kinect-audio.nixosModules.default
          ./hosts/${hostname}
          ./hosts/${hostname}/hardware-configuration.nix
          ({pgks, ...}: {
            system.nixos.label =
              if self ? rev
              then self.rev
              else throw "Refusing to build from dirty Git tree!";
          })
        ];
    };
  };
}
