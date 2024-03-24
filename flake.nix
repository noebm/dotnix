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
    systemConfig = {
      hostname = "nixos";
      system = "x86_64-linux";
    };
    userConfig = {
      user = "noebm";
      email = "moritz.noebauer@gmail.com";
    };
    pkgs = import nixpkgs {
      system = "${systemConfig.system}";
      config.allowUnfree = true;
    };
    hardwareConfig = [./hardware-configuration.nix];
    homeConfig = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.${userConfig.user} = import ./home.nix {
          inherit pkgs;
          nixvim = inputs.nixvim;
        };
      }
    ];
  in {
    nixosConfigurations.${systemConfig.hostname} = nixpkgs.lib.nixosSystem {
      system = systemConfig.system;
      specialArgs = {inherit inputs systemConfig userConfig;};
      modules =
        hardwareConfig
        ++ homeConfig
        ++ [
          ./configuration.nix
          {
            services.udev.packages = [kinect-audio.packages."${systemConfig.system}".default];
          }
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
