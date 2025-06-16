{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Cli Tools
    bat
    cmatrix
    eza
    fastfetch
    fd
    fzf
    ripgrep
    wget
    yazi
    zoxide

    # Editor
    neovim
    lazygit

    # Shell Evironment
    fish
    nushell
    starship
    tmux
  ];

  home.file = {
    ".config/starship.toml".source = ../dotfiles/starship.toml;

    ".config/ghostty/config".text = ''
      theme = hopscotch.256

      font-family = "FiraCode Nerd Font Mono"
      font-size = 14
      # font-thicken = true

      background-blur = 20
      background-opacity = 1
      window-padding-x = 10
      window-padding-y = 10

      mouse-hide-while-typing = true
      # shell-integration = fish
      # command = /Users/devonwalker/.nix-profile/bin/fish 

      keybind = global:opt+grave_accent=toggle_quick_terminal
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "1337";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--border rounded"
      "--layout reverse"
      "--info right"
    ];
    colors = {
      fg = "#cbccc6";
      "fg+" = "#707a8c";
      bg = "#1f2430"; 
      "bg+" = "#191e2a";
      hl = "#707a8c"; 
      "hl+" = "#ffcc66";
      info = "#73d0ff";
      prompt = "#707a8c";
      pointer = "#cbccc6";
      marker = "#73d0ff";
      spinner = "#73d0ff";
      header = "#d4bfff";
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
        ratio = [ 1 3 4 ];
      };
    };
    theme = {
      flavor = {
        dark = "vscode-dark-plus";
        light = "vscode-light-plus";
      };
    };
    flavors = {
      vscode-dark-plus = pkgs.fetchFromGitHub {
        owner = "956MB";
        repo = "vscode-dark-plus.yazi";
        rev = "main";
        hash = "sha256-YhHIYKaA4m0ok7vSMwX1TNLGLN2Z2ACciIbJAm6PmJM=";
      };
      vscode-light-plus = pkgs.fetchFromGitHub {
        owner = "956MB";
        repo = "vscode-light-plus.yazi";
        rev = "main";
        hash = "sha256-YhHIYKaA4m0ok7vSMwX1TNLGLN2Z2ACciIbJAm6PmJM=";
      };
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
      bind - split-window -vc "#{pane_current_path}"
      bind | split-window -hc "#{pane_current_path}"
      # unbind '"'
      # unbind %

      # panes
      set -g status-position top
    '';
  };

  programs.fish = {
    enable = true;
    shellInitLast = ''
      # Load Starship prompt
      starship init fish | source

      # Load zoxide
      zoxide init --cmd j fish | source
    '';
    shellAliases = {
      g = "git";
      gst = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gb = "git branch";
      gco = "git checkout";
      gd = "git diff";
      gcl = "git clone";
      ll = "exa --icons --group-directories-first --header --long";
      la = "exa --icons --group-directories-first --header --long --all";
      lt = "exa --icons --group-directories-first --tree --level=2";
      cat = "bat";
      ".c" = "cd ~/.config";
    };
    shellAbbrs = {};
    functions = {
      fish_greeting = ''
        fastfetch
      '';
    };
    plugins = with pkgs; [
      {
        name = "done";
        src = fishPlugins.done.src;
      }
      {
        name = "macos";
        src = fishPlugins.macos.src;
      }
      {
        name = "pisces";
        src = fishPlugins.pisces.src;
      }
      {
        name = "puffer";
        src = fishPlugins.puffer.src;
      }
    ];
  };

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "nullxception/roundy"
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
    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          autoload -U compinit && compinit
        '';
        zshConfig = lib.mkOrder 1500 ''
          # Working Directory Info Mode
          # Valid choice are : "full", "short", or "dir-only"
          ROUNDY_DIR_MODE="full"

          # The next line updates PATH for the Google Cloud SDK.
          if [ -f '/Users/devonwalker/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/devonwalker/google-cloud-sdk/path.zsh.inc'; fi

          # The next line enables shell command completion for gcloud.
          if [ -f '/Users/devonwalker/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/devonwalker/google-cloud-sdk/completion.zsh.inc'; fi

          # eval "$(starship init zsh)"

          eval "$(zoxide init zsh)"
        '';
      in lib.mkMerge [ zshConfigEarlyInit zshConfig ];
  };
}
