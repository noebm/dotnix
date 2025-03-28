{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "noebm";
      homeConfig = unstable: [
        (
          if unstable then
            inputs.home-manager-unstable.nixosModules.home-manager
          else
            inputs.home-manager.nixosModules.home-manager
        )
        ({
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs system; };

          users.users.${user} = {
            isNormalUser = true;
            extraGroups = [
              "wheel" # Enable ‘sudo’ for the user.
              "corectrl" # Enable usage of `programs.corectrl`
            ];
          };
          home-manager.users.${user} = import ./home.nix;
        })
      ];
      # homeSetup = user: {
      #   home.username = user;
      #   home.homeDirectory = "/home/${user}";
      #   nixpkgs.config.allowUnfree = true;
      # };

      mkHosts = builtins.mapAttrs (hostname: config: config hostname);
    in
    {
      # homeConfigurations."${user}@harpsichord" = home-manager.lib.homeManagerConfiguration {
      #   modules = [
      #     ./home.nix
      #     (homeSetup user)
      #   ];
      #   extraSpecialArgs = { inherit inputs system; };

      #   pkgs = import nixpkgs {
      #     inherit system;
      #   };
      # };

      nixosConfigurations = mkHosts {
        harpsichord =
          hostname:
          inputs.nixpkgs-unstable.lib.nixosSystem {
            specialArgs = {
              inherit
                self
                inputs
                system
                hostname
                ;
            };
            modules = homeConfig true ++ [
              ./hosts/${hostname}
            ];
          };

        tambourine =
          hostname:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                self
                inputs
                system
                hostname
                ;
            };
            modules = homeConfig false ++ [
              ./hosts/${hostname}
            ];
          };
      };
    };
}
