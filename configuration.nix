{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  mypkgs = import ./packages { inherit pkgs lib; };
  chaotic = import inputs.chaotic.inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
    overlays = [
      inputs.chaotic.overlays.default
    ];
  };
in
{
  imports = [ ];

  boot = {
    loader = {

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1024x768";
      };
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    tmp.cleanOnBoot = true;

    kernelPackages = chaotic.linuxPackages_cachyos;

    kernel.sysctl."kernel.sysrq" = 502;
  };

  services = {
    displayManager = {
      ly = {
        enable = true;
        settings = {
          allow_empty_password = false;
          auth_fails = 3;
          bigclock = "en";
          vi_mode = true;
          vi_default_mode = "insert";
        };
      };
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    earlyoom = {
      enable = true;
      extraArgs = [
        "-m 5,2"
        "-s 5,2"
      ];
    };

    interception-tools.enable = true;

    flatpak = {
      enable = true;
      update.auto.enable = false;
      uninstallUnmanaged = true;

      packages = [
        "org.vinegarhq.Sober"
        "com.github.wwmm.easyeffects"
        "io.github.Soundux"
      ];
    };

    gnome.gnome-keyring.enable = true;

    vnstat.enable = true;

    postgresql.enable = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  users.users.fil = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  hardware = {

    graphics.enable = true;
    bluetooth.enable = true;
    i2c.enable = true;
  };

  security = {
    sudo.extraRules = [
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
    pam.services.ly.enableGnomeKeyring = true;
  };

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
    gh
    pgcli
    mypkgs.vi-sql
    mypkgs.resterm

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
    mypkgs.discover-overlay
    pinta
    polychromatic
    mypkgs.crosshair

    cliphist
    hyprsunset
    ddcutil
    vnstat
    libnotify

    nwg-displays
    nwg-bar
    swaynotificationcenter
    pulseaudio
    playerctl

    mint-x-icons

    prismlauncher
    mangohud

    kitty
    yazi
    unar
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
    spotify
    proton-vpn-cli

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

  programs = {

    zsh.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    gpu-screen-recorder.enable = true;
    hyprlock.enable = true;
    tmux.enable = true;

    hyprland.enable = true;
    hyprland.withUWSM = true;

    dconf.profiles.user.databases = [
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
  };

  virtualisation.podman.enable = true;
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

  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  system.stateVersion = "26.05";
}
