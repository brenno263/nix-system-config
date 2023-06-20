{pkgs, ...}: {
  # Here go darwin preferences and config items
  users.users.bseymour.home = "/Users/bseymour";
  programs.zsh.enable = true;
  environment.shells = [pkgs.bash pkgs.zsh];
  environment.loginShell = pkgs.zsh;
  environment.systemPackages = with pkgs; [
    coreutils
    rustup
    python311
    nodejs_20
    azure-cli
    awscli2
  ];
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    onActivation.cleanup = "zap";
    masApps = {};
    casks = ["raycast" "spotify" "firefox" "discord"];
    brews = [];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  fonts.fontDir.enable = true; # Danger? This will use ONLY these fonts
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo"];})];
  services.nix-daemon.enable = true;

  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      top_padding = 12;
      right_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      window_gap = 12;
      mouse_follows_focus = "off";
      focus_follows_mouse = "on";
      mouse_modifier = "ctrl";
      mouse_action1 = "move";
      mouse_action2 = "resize";
    };
    extraConfig = ''
      yabai -m mouse_drop_action swap
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
    '';
  };
  services.skhd = {
    enable = true;
    skhdConfig = let
      mod = "alt";
    in ''
      # Change Window
      ${mod} - h : yabai -m window --focus west
      ${mod} - j : yabai -m window --focus south
      ${mod} - k : yabai -m window --focus north
      ${mod} - l : yabai -m window --focus east

      # Change Display
      # ${mod} - p : yabai -m display --focus west
      # ${mod} - n : yabai -m display --focus east

      # Rotate & Flip
      shift + ${mod} - r : yabai -m space --rotate 90
      shift + ${mod} - y : yabai -m space --mirror y-axis
      shift + ${mod} - x : yabai -m space --mirror x-axis

      # Grid notation is rows:cols:x:y:width:height, where rows:cols defines the grid space
      shift + ${mod} - f : yabai -m window --toggle float --grid 4:4:1:1:2:2

      shift + ${mod} - m : yabai -m window --toggle zoom-fullscreen
      shift + ${mod} - b : yabai -m space --balance

      # Push Windows Around
      shift + ${mod} - h : yabai -m window --swap west
      shift + ${mod} - j : yabai -m window --swap south
      shift + ${mod} - k : yabai -m window --swap north
      shift + ${mod} - l : yabai -m window --swap east

      ctrl + ${mod} - h : yabai -m window --warp west
      ctrl + ${mod} - j : yabai -m window --warp south
      ctrl + ${mod} - k : yabai -m window --warp north
      ctrl + ${mod} - l : yabai -m window --warp east

      # Move Windows Around Spaces
      shift + ${mod} - p : yabai -m window --space prev
      shift + ${mod} - n : yabai -m window --space next
      shift + ${mod} - 1 : yabai -m window --space 1
      shift + ${mod} - 2 : yabai -m window --space 2
      shift + ${mod} - 3 : yabai -m window --space 3
      shift + ${mod} - 4 : yabai -m window --space 4
      shift + ${mod} - 5 : yabai -m window --space 5
      shift + ${mod} - 6 : yabai -m window --space 6
      shift + ${mod} - 7 : yabai -m window --space 7
      shift + ${mod} - 8 : yabai -m window --space 8
      shift + ${mod} - 9 : yabai -m window --space 9

      # App Shortcuts
      ${mod} - return: open -na /Users/bseymour/Applications/"Home Manager Apps"/Alacritty.app
    '';
  };

  system = {
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToEscape = true;
    keyboard.swapLeftCommandAndLeftAlt = true;
    defaults.finder.AppleShowAllExtensions = true;
    defaults.finder._FXShowPosixPathInTitle = true;
    defaults.NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTableViewDefaultSizeMode = 2;
      NSWindowResizeTime = 0.0;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.springing.enabled" = false;
      "com.apple.swipescrolldirection" = true;
    };
    defaults.dock = {
      autohide = true;
      launchanim = false;
      mineffect = "scale";
      show-recents = false;
      tilesize = 64;
    };
    defaults.screencapture.disable-shadow = true;
    defaults.screencapture.location = "/Users/bseymour/Pictures/Screenshots";
    defaults.screencapture.type = "png";
    defaults.trackpad.Clicking = true;
  };
}
