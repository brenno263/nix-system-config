{pkgs, pwnvim, ...}: {
  #backwards-compat measure, do not change
  home.stateVersion = "22.11";

  #specify my home-manager configs
  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.curl
    pkgs.less
    pwnvim.packages."x86_64-darwin".default
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
  };
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.exa.enable = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.shellAliases = {ls = "ls --color=auto -F";};
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.alacritty = {
    enable = true;
    settings.font.normal.family = "MesloLGS Nerd Font Mono";
    settings.font.size = 16;
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
