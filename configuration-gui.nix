{ lib, pkgs, ... }:
{
  specialisation = {
    gui.configuration = {
      # Login and Desktop Management
      services.xserver = {
        enable = true;
        desktopManager = {
          xterm.enable = false;
          xfce.enable = true;
        };
        displayManager = {
          lightdm.enable = true;
        };
      };
    };
  };
}
