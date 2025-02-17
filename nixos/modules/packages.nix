{ config, pkgs, ... }:

#####################################
### Dis tha place to put packages ###
#####################################
{
  # TODO: Automate organization & installation via script
  environment.systemPackages = with pkgs; [
    spotify
  ];
}
