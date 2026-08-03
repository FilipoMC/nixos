{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "filipo";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  fileSystems."/run/media/fil/arch" = {
    device = "/dev/disk/by-uuid/0bd34ee6-e4bd-465d-b03f-b404e982ed3a";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ];
}
