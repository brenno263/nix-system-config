{
  pkgs,
  pwnvim,
  ...
}: {
  #backwards-compat measure, do not change
  home.stateVersion = "22.11";

  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.curl
    pkgs.less
    pkgs.cowsay
    #pwnvim.packages."x86_64-darwin".defaut
    pkgs.vimPlugins.LazyVim
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
  };
  programs.neovim.enable = true;
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.exa.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.shellAliases = {
    ls = "ls --color=auto -F";
    nixupdate = "pushd ~/src/system-config; nix flake update; nixswitch; popd";
    nixswitch = "darwin-rebuild switch --flake ~/src/system-config/.#";
    bruh = "cowsay bruh";
    pdfmerge = "'/System/Library/Automator/Combine PDF Pages.action/Contents/MacOS/join' -o merged.pdf ./*.pdf";
  };
  programs.zsh.initExtra = ''
    function lazygit() {
      git add --all
      git commit -m "$1"
      git push
    }
  '';
  programs.zsh.profileExtra = ''
    export PATH="$PATH:/Users/bseymour/Library/Python"
    eval "$(/usr/local/bin/brew shellenv)"
  '';
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "MesloLGS Nerd Font Mono";
    settings.font.size = 16;
  };
  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      st = "status";
      cm = "commit";
    };
    delta.enable = true;
    userEmail = "bseymour@sourceallies.com";
    userName = "Brennan Seymour";
  };
  home.file.".inputrc".text = ''
    set show-all-if-ambiguous on
    set completion-ignore-case on
    set mark-directories on
    set mark-symlinked-directories on
    set match-hidden-files off
    set visible-stats on
    set keymap vi
    set editing-mode vi-insert
  '';
}
