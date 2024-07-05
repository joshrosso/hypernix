{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "josh";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    tmux
    nil
    gh
    nixfmt
    starship
    crane
    jq
    wget
    kubectx
    gopls
    kubectl
    go
    htop
    unzip
    tree
    pinentry
    gnupg
    google-cloud-sdk
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs; [
      vimPlugins.catppuccin-nvim
      vimPlugins.telescope-nvim
      vimPlugins.vim-fugitive
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-eunuch
      vimPlugins.vim-gitgutter
      vimPlugins.vim-nix
      vimPlugins.typescript-vim
      vimPlugins.vim-monokai-pro
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-web-devicons
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp-cmdline
      vimPlugins.nvim-cmp
      vimPlugins.cmp-vsnip
      vimPlugins.vim-vsnip
      vimPlugins.trouble-nvim
    ];

    extraLuaConfig = (builtins.readFile ./vim.lua);
  };

  programs.git = {
    enable = true;
    userName = "joshrosso";
    userEmail = "joshrosso@gmail.com";
    signing = {
      key = "B076918EE70E30CF98B2EB4AD5CD572310881E88";
      signByDefault = false;
    };
    extraConfig = {
      push.default = "current";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "h1" = {
        user = "root";
        identityFile = "~/.ssh/homelab";
      };
      "h2" = {
        user = "root";
        identityFile = "~/.ssh/homelab";
      };
      "fenix" = {
        user = "josh";
        identityFile = "~/.ssh/joshrosso.pem";
      };
      "github.com" = {
        user = "joshrosso";
        identityFile = "~/.ssh/joshrosso.pem";
      };
      "192.168.*" = {
        user = "josh";
        identityFile = "~/.ssh/joshrosso.pem";
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      g = "git";
      v = "nvim";
    };
  };

  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
