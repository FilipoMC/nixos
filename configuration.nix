{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  mypkgs = import ./packages { inherit pkgs lib; };
  chaotic = import inputs.chaotic.inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    overlays = [
      inputs.chaotic.overlays.default
    ];
  };
in
{
  imports = [ ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.gfxmodeEfi = "1024x768";
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    allow_empty_password = false;
    auth_fails = 3;
    bigclock = "en";
    vi_mode = true;
    vi_default_mode = "insert";
  };

  boot.tmp.cleanOnBoot = true;

  boot.kernelPackages = chaotic.linuxPackages_cachyos;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.fil = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "input"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

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

  services.interception-tools.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "fil" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start interception-tools";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop interception-tools";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.flatpak.enable = true;
  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  services.vnstat.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
    killall

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
    distrobox

    fuzzel
    pyprland
    mypkgs.waybar
    hyprpaper
    hypridle
    hyprpicker
    wl-clipboard
    bluetui
    pulsemixer
    grimblast
    flameshot
    mpv
    numr
    discover-overlay

    cliphist
    hyprsunset
    ddcutil
    vnstat
    libnotify

    nwg-displays
    nwg-bar
    swaynotificationcenter
    pulseaudio

    mint-x-icons

    prismlauncher
    mangohud

    kitty
    mypkgs.yazi
    unar
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
    spotify
    proton-vpn-cli

    zsh
    eza
    zoxide
    lazygit
    atuin
    fastfetch
    hyfetch
    ookla-speedtest
    aria2
    imagemagick
    ffmpeg
    yt-dlp

  ];

  programs.nix-ld.enable = true;
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
  programs.gpu-screen-recorder.enable = true;
  programs.hyprlock.enable = true;
  virtualisation.podman.enable = true;

  services.flatpak.packages = [
    "org.vinegarhq.Sober"
    "com.github.wwmm.easyeffects"
    "io.github.Soundux"
  ];

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

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
        gtk-theme = "Adwaita-dark";
        icon-theme = "Mint-X-Aqua";
        font-name = "FreeSans Regular 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "CodeNewRoman Nerd Font Mono 11";
        gtk-application-prefer-dark-theme = true;
        color-scheme = "prefer-dark";
      };
    }
  ];

  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  system.stateVersion = "26.05";
}
