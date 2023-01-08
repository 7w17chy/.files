{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thulis";
  home.homeDirectory = "/home/thulis";

  # swap caps lock and control
  home.keyboard.options = [ "ctrl:swapcaps" ];

  # packages to install
  home.packages = with pkgs; [
    bat
    lazygit
    exa
    syncthing
    fish
    emacs
  ];

  # emacs config
  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/settings.org".source = ./settings.org;
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # git config
  programs.git = {
    enable = true;
    userName = "Max Nerius";
    userEmail = "nermax03@gmail.com";
  };

  # fish config
  programs.fish.plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
        sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      };
    }
  ];
  programs.fish.interactiveShellInit = ''
set -l nix_shell_info (
  if test -n "$IN_NIX_SHELL"
    echo -n "<nix-shell> "
  end
)
  '';                        
  programs.fish.shellAbbrs = {
    lg = "lazygit";
    ls = "exa";
    ll = "exa -l";
    la = "exa -la";
    cat = "bat";
  };

  # syncthing config
  services.syncthing.enable = true;

  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
