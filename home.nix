{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thulis";
  home.homeDirectory = "/home/thulis";

  # packages to install
  home.packages = with pkgs; [
    bat
    lazygit
    exa
  ];

  # emacs config
  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/settings.org".source = ./settings.org;

  programs.git = {
    enable = true;
    userName = "Max Nerius";
    userEmail = "nermax03@gmail.com";
  };

  programs.fish.enable = true;
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
  };

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
