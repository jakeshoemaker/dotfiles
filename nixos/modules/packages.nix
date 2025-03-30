{ config, pkgs, ... }:

#####################################
### Dis tha place to put packages ###
#####################################

{
  environment.systemPackages = with pkgs; [
    spotify
  ];
}
