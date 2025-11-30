{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>

    ./modules/networking.nix
    ./modules/desktop.nix
    ./modules/sound.nix
    ./modules/services.nix
    ./modules/users.nix
    ./modules/home-amaury.nix
    ./modules/fileserver.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Send kernel messages + login prompt to serial
  boot.kernelParams = [
    "console=tty0"                 # keep normal console
    "console=ttyS0,115200n8"       # serial console for Proxmox
  ];

  # Tell GRUB to also use the serial port
  boot.loader.grub.extraConfig = ''
     serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
     terminal_input serial console
     terminal_output serial console
  '';


  # Time & locale.
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
