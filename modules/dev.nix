{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Programming Language
    go
    openjdk21
    # pnpm

    # Programming Tools
    gh
    httpie
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Devon";
      user.email = "devon.dana@gmail.com";
      push.autoSetupRemote = true;
    };
  };
}
