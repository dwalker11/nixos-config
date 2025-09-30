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
    # jq
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
    # colors = {
    #   fg = "#cbccc6";
    #   "fg+" = "#707a8c";
    #   bg = "#1f2430"; 
    #   "bg+" = "#191e2a";
    #   hl = "#707a8c"; 
    #   "hl+" = "#ffcc66";
    #   info = "#73d0ff";
    #   prompt = "#707a8c";
    #   pointer = "#cbccc6";
    #   marker = "#73d0ff";
    #   spinner = "#73d0ff";
    #   header = "#d4bfff";
    # };
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
      # flavor = {
      #   dark = "vscode-dark-plus";
      #   light = "vscode-light-plus";
      # };
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
      backup_file = ''
        function rename_old --description "Rename a file by appending .old extension"
            # Check if argument is provided
            if test (count $argv) -eq 0
                echo "Usage: rename_old <filename>"
                echo "Renames the specified file by appending '.old' to its name"
                return 1
            end
            
            set file $argv[1]
            
            # Check if file exists
            if not test -e "$file"
                echo "Error: File '$file' does not exist"
                return 1
            end
            
            # Check if target file already exists
            set new_name "$file.old"
            if test -e "$new_name"
                echo "Error: Target file '$new_name' already exists"
                return 1
            end
            
            # Rename the file
            if mv "$file" "$new_name"
                echo "Successfully renamed '$file' to '$new_name'"
            else
                echo "Error: Failed to rename '$file'"
                return 1
            end
        end
      '';
      leetcode_py = ''
        function leetcode_py --description "Create a Python file in Code/Leetcode directory from a text string"
          # Check if argument is provided
          if test (count $argv) -eq 0
              echo "Usage: leetcode_py <text string>"
              echo "Creates a Python file in ~/Code/Leetcode/ with filename based on the text string"
              echo "Example: leetcode_py 'two sum problem' -> creates two_sum_problem.py"
              return 1
          end
          
          # Join all arguments into a single string
          set text_string (string join " " $argv)
          
          # Convert to lowercase and replace spaces/dashes with underscores
          set filename (string lower $text_string | string replace -a " " "_" | string replace -a "-" "_")
          
          # Remove any characters that aren't alphanumeric, underscore, or hyphen
          set filename (string replace -ra '[^a-z0-9_]' ''' $filename)
          
          # Ensure filename doesn't start with a number (invalid Python module name)
          if string match -qr '^[0-9]' $filename
              set filename "problem_$filename"
          end
          
          # Add .py extension
          set filename "$filename.py"
          
          # Set the target directory
          set target_dir "$HOME/Code/Leetcode"
          set full_path "$target_dir/$filename"
          
          # Check if Code/Leetcode directory exists, create if it doesn't
          if not test -d "$target_dir"
              echo "Creating directory: $target_dir"
              mkdir -p "$target_dir"
          end
          
          # Check if file already exists
          if test -e "$full_path"
              echo "Error: File '$filename' already exists in $target_dir"
              return 1
          end
          
          # Create the Python file with basic template
          cat > "$full_path" << 'EOF'
      """
      TODO: Add problem description here
      """


      def solution():
          """
          TODO: Implement solution
          """
          pass


      def main():
          # Test cases
          pass


      if __name__ == "__main__":
          main()
      EOF
          
          echo "Successfully created: $full_path"
          echo "Filename: $filename"
      end
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

          # pnpm
          export PNPM_HOME="/Users/devonwalker/Library/pnpm"
          case ":$PATH:" in
            *":$PNPM_HOME:"*) ;;
            *) export PATH="$PNPM_HOME:$PATH" ;;
          esac
          # pnpm end

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
