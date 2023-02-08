{ config, pkgs, ... }:

{
  # swap caps lock and control
  home.keyboard.options = [ "ctrl:swapcaps" ];

  # nixpkgs settings
  nixpkgs = {
    overlays = [
      (import (builtins.fetchTarball {
        url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];
    config = { allowUnfree = true; };
  };

  # packages to install
  home.packages = with pkgs; [
    kitty
    neovim
    neovide
    bat
    lazygit
    exa
    syncthing
    zsh
    starship
    hexchat
    chromium
    gnome.gnome-tweaks
    direnv
    fzf
    mu
    discord
    offlineimap

    # customized emacs
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      package = pkgs.emacs;
      
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
        auto-compile
        gruvbox-theme
        whole-line-or-region
        org-bullets
        magit
        cdlatex
        epkgs.direnv # beware of the pkgs.direnv <-> epkgs.direnv confusion!
        pdf-tools
        mu
        mu4e-alert
      ];
    })
  ];

  # git config
  programs.git = {
    enable = true;
    userName = "Max Nerius";
    userEmail = "nermax03@gmail.com";
  };

  # automagically sync mail
  programs.offlineimap = {
    enable = true;
  };

  # zsh config
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      lg = "lazygit";
      cat = "bat";
    };
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf-zsh-plugin" ];
    };
  };

  # shell prompt customization
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      scan_timeout = 10;
      character = {
        success_symbol = "λ";
      };
      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold green)";
        pure_msg = "[pure shell](bold green)";
        format = "via [☃ $state( \($name\))](bold blue) ";
      };
    };
  };

  # hexchat config
  programs.hexchat = {
    enable = true;
    settings = {
      irc_nick1 = "nullptrexcptn";
      irc_nick2 = "bytebender";
      irc_username = "nullptrexcptn";
    };
  };

  # chromium config
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "dcpihecpambacapedldabdbpakmachpb"; # bypass paywalls
        updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
      }
      { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # community version of 'i don't care about cookies' 
    ];
  };

  # system services
  # TODO: abstract into function
  services = {
    emacs.enable = true;
    dropbox = {
      enable = true;
      path = "${config.home.homeDirectory}/Dropbox";
    };
  };

  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
