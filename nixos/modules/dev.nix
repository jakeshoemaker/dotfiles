{ config, pkgs, ... }:
 
{
  # Shell packages
  environment.systemPackages = with pkgs; [
    cmake 
    curl
    direnv
    erlang_nox
    eww
    fd
    font-awesome
    fzf
    gcc
    git
    gleam
    go
    htop
    jq
    lazygit
    lazydocker
    neofetch
    neovim
    rustup
    ripgrep
    rebar3
    starship
    stow
    tmux
    tree
    uv
    wget
    zsh
  ];
  

  # Shell configuration
  programs.zsh.enable = true;
  programs.starship.enable = true;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      user.name = "jakeshoemaker";
      user.email = "jakeshoe3@gmail.com";
      init.defaultBranch = "main";
    };
  };

  # Install Nerdfonts
  fonts.packages = with pkgs; [
    nerd-fonts.agave
    nerd-fonts.fira-code
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.lilex
    nerd-fonts.symbols-only
    nerd-fonts.zed-mono
    (stdenv.mkDerivation {
      name = "agave-code";
      src = fetchurl {
        url = "https://github.com/pavel/agave-code/raw/refs/heads/master/AgaveCode.ttf";
        sha256 = "0785z0iz55b3nasdzrin7gfr5rid3zcnavq31v95wqg50xw7w4pi";
      };
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src $out/share/fonts/truetype/
      '';
    })
  ];
}
