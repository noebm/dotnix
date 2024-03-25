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
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    kinect-audio,
    ...
  } @ inputs: let
    hostname = "nixos";
    system = "x86_64-linux";
    userConfig = {
      user = "noebm";
      email = "moritz.noebauer@gmail.com";
      name = "Moritz Noebauer";
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    homeConfig = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.${userConfig.user} = import ./home.nix {
          inherit userConfig pkgs nixvim;
        };
      }
    ];
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs userConfig system hostname;};
      modules =
        homeConfig
        ++ [
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
