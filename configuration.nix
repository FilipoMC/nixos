{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  mypkgs = import ./packages { inherit pkgs lib; };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "filipo";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.fil = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 502;
  services.earlyoom = {
    enable = true;
    extraArgs = [
      "-m 5,2"
      "-s 5,2"
    ];
  };

  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.vnstat.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    btop
    gnugrep
    gnumake
    cmake
    unzip
    jq
    p7zip
    file

    nodejs
    pnpm
    gcc
    rustup

    ripgrep
    repgrep
    fd
    fzf
    chafa
    bat
    tree-sitter
    stow
    ncdu
    dust
    mypkgs.yscan

    interception-tools-plugins.caps2esc

    fuzzel
    pyprland
    mypkgs.waybar
    hyprpaper
    hypridle
    hyprpicker
    hyprlock
    wl-clipboard
    bluetui
    pulsemixer
    grimblast
    flameshot

    cliphist
    hyprsunset
    ddcutil
    vnstat
    libnotify

    nwg-displays
    nwg-look
    nwg-bar
    swaynotificationcenter
    pulseaudio

    mint-x-icons
    mint-themes

    prismlauncher

    kitty
    mypkgs.yazi
    unar
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
    spotify

    zsh
    eza
    zoxide
    lazygit
    atuin
    fastfetch
    ookla-speedtest
    aria2
    imagemagick

  ];

  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.packages = [
    "org.vinegarhq.Sober"
    "com.github.wwmm.easyeffects"
    "io.github.Soundux"
  ];

  programs.hyprland.enable = true;
  programs.steam.enable = true;

  services.displayManager.ly.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
    font-awesome
    corefonts
    vista-fonts
    noto-fonts
    noto-fonts-cjk-sans
    dejavu_fonts
    liberation_ttf
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Mint-Y-Dark";
        icon-theme = "Mint-X-Aqua";
        font-name = "FreeSans Regular 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "CodeNewRoman Nerd Font Mono 11";
        gtk-application-prefer-dark-theme = true;
        color-scheme = "prefer-dark";
      };
    }
  ];

  system.stateVersion = "26.05";
}
