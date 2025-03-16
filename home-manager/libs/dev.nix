{ config, pkgs, ... }:

{
  home.packages = [
    # Editors
    # pkgs.zed-editor
    pkgs.neovim

    # Programming Languages
    pkgs.go
    pkgs.nodejs_23
    pkgs.openjdk21

    # Programming Tools
    pkgs.gh
    pkgs.httpie
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    userName = "Devon";
    userEmail = "devon.dana@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };
}
