# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  hostname,
  system,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # FIXME not working with kernel 6.14
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # check for x86_64-linux?
    inputs.kinect-firmware-utils.nixosModules.${system}.default
    ../../modules/nixos
    ../../modules/nixos/wm
    ../../modules/nixos/overclocking.nix
    ../../modules/nixos/kde-connect.nix
    ../../modules/nixos/ps5-controller.nix
    ../../modules/nixos/printer.nix
    ../../modules/nixos/logitech.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/zwift.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # use tmpfs for /tmp
  # this is disabled by default because it can cause (large) builds to fail
  boot.tmp.useTmpfs = true;

  networking.hostName = hostname;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # enable for sops host key generation
  services.openssh.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  services.open-webui.enable = true;

  environment.systemPackages = with pkgs; [ rocmPackages.rocminfo ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # Enable A2DP Sink
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
  };

  services.fwupd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8000 ];
    allowedUDPPorts = [ 8000 ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # DO NOT MODIFY!
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
