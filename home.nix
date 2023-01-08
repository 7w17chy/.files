{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thulis";
  home.homeDirectory = "/home/thulis";

  # packages to install
  home.packages = with pkgs; [
    bat
  ];

  # porting over dotfiles:
  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/settings.org".source = ./settings.org;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
