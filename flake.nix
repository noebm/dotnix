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
  in {
    nixosConfigurations.${systemConfig.hostname} = nixpkgs.lib.nixosSystem {
      system = systemConfig.system;
      specialArgs = {inherit inputs systemConfig userConfig;};
      modules = [
        ./configuration.nix
        kinect-audio.nixosModules.default
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
