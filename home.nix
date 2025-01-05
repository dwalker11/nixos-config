{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "devonwalker";
  home.homeDirectory = "/Users/devonwalker";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Cli Tools
    bat
    cmatrix
    fd
    fzf
    lf
    tree

    # Editors
    lunarvim
    neovim

    # Programming Language
    go

    # Programming Tools
    gh
    httpie

    # Terminals
    kitty
    starship
    tmux
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/kitty/kitty.conf".source = dotfiles/kitty.conf;
    # ".config/starship.toml".source = dotfiles/starship.toml;
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
  #  /etc/profiles/per-user/devonwalker/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    TERM = "xterm-256color";
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
    clock24 = false;
    baseIndex = 1;
    # prefix = 'C-Space';
    sensibleOnTop = true;
    terminal = "xterm-256color";
    plugins = with pkgs; [
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-left-icon "#S"
          set -g @dracula-show-left-icon-padding 1
          set -g @dracula-plugins "git time"
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
      bind - split-window -vc "#{pane_current_path}"
      bind | split-window -hc "#{pane_current_path}"
      # unbind '"'
      # unbind %

      # panes
      set -g status-position top
    '';
  };

  programs.zsh = {
    enable = true;
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
      # The next line updates PATH for the Google Cloud SDK.
      if [ -f '/Users/devonwalker/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/devonwalker/google-cloud-sdk/path.zsh.inc'; fi

      # The next line enables shell command completion for gcloud.
      if [ -f '/Users/devonwalker/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/devonwalker/google-cloud-sdk/completion.zsh.inc'; fi

      eval "$(starship init zsh)"
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
