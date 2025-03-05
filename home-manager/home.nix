{ config, pkgs, ... }:

{
  home.username = "devon";
  home.homeDirectory = "/home/devon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Cli Tools
    bat
    btop
    cmatrix
    fd
    fzf
    lazygit
    lf
    ripgrep
    tree
    wget
    yt-dlp

    # Editors
    neovim
    # zed-editor

    # Programming Languages
    go
    nodejs_22

    # Programming Tools
    gh
    httpie

    # Terminal
    nushell
    # ghostty
    kitty
    starship
    tmux
  ];

  home.file = {
    ".config/ghostty/config".source = configs/ghostty/config;
    ".config/kitty/kitty.conf".source = configs/kitty/kitty.conf;
    ".config/starship.toml".source = configs/starship/starship.toml;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/devon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERM = "xterm-256color";
  };

  # fonts = {};

  # gtk = {};

  programs.ssh = {
      enable = false;
  };

  programs.git = {
    enable = true;
    userName = "Devon";
    userEmail = "devon.dana@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    sensibleOnTop = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
        '';
      }
    ];
    extraConfig = ''
      # Reload config file
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Switch panes using Alt-arrow without prefix
      bind-key h select-pane -L
      bind-key l select-pane -R
      bind-key k select-pane -U
      bind-key j select-pane -D

      # Open panes in the current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Set status bar to the top position
      set-option -g status-position top
    '';
  };

  programs.zsh = {
    enable = false;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "rupa/z"
        "MichaelAquilina/zsh-you-should-use"
        "ohmyzsh/ohmyzsh path:plugins/common-aliases"
        "ohmyzsh/ohmyzsh path:plugins/fzf"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/tmux"
        "ohmyzsh/ohmyzsh path:plugins/web-search"
      ];
    };
    autocd = true;
    autosuggestion.enable = true;
    history.share = true;
    history.ignoreAllDups = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = false;
    initExtraFirst = ''
      autoload -U compinit && compinit
    '';
    initExtra = ''
      export NVM_DIR="$([ -z "''${XDG_CONFIG_HOME-}" ] && printf %s "''${HOME}/.nvm" || printf %s "''${XDG_CONFIG_HOME}/nvm")"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

      eval "$(starship init zsh)"
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
