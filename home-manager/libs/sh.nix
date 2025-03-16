{ config, pkgs, ... }:

{
  home.packages = [
    # pkgs.ghostty
    pkgs.kitty
    # pkgs.fish
    # pkgs.zsh
    pkgs.nushell
    pkgs.starship
    pkgs.tmux
  ];

  home.file = {
    ".config/ghostty/config".source = ../configs/ghostty/config;
    ".config/kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
    ".config/starship.toml".source = ../configs/starship/starship.toml;
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
          set -g @dracula-refresh-rate 5
          set -g @dracula-show-empty-plugins false
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
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      # unbind '"'
      # unbind %

      # Set status bar to the top position
      set-option -g status-position top
    '';
  };

  programs.fish = {
    enable = false;
  };

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        # "rupa/z"
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
}
