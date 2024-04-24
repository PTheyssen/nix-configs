# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  ## enable firmware updates => trying to solve hdmi issue on thinkpad carbon x1
  services.fwupd.enable = true;

  
  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "xfce+i3";
  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
  };
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [ dmenu i3status ];
  };

  # azure data studio had 
  services.gnome.gnome-keyring.enable = true;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
    xkbOptions =
      "ctrl:nocaps"; # This option disables Caps Lock and sets it as Control.
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pt = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    martian-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (agda.withPackages [ agdaPackages.standard-library ])
    acpi
    android-studio
    alacritty
    anki
    binutils
    calibre
    chromium
    cloudcompare
    cmus
    darktable
    drawio
    dig
    emacs
    ffmpeg
    file
    firefox
    freeplane
    fzf
    gcc
    ghc
    gdb
    gimp
    git
    glibcInfo
    gnome.cheese
    gnome.dconf-editor
    gnome.nautilus
    gnome.pomodoro
    gnupg
    graphviz
    gnuplot
    htop
    iotop
    ispell
    inkscape
    jq
    jetbrains.clion
    killall
    klavaro
    kubectl
    libreoffice
    libsForQt5.kdenlive
    man-pages
    minikube
    mailutils
    mplayer
    mpv
    ncdu
    nload
    nextcloud-client
    nixfmt
    nmap
    ntfs3g
    openscad
    pandoc
    pass
    pavucontrol
    pdfarranger
    pdftk
    pinentry
    powertop
    python312
    qtpass
    ranger
    redshift
    restic
    ripgrep
    jetbrains.rider
    rofi
    screen-message
    simplescreenrecorder
    scrot
    sqlitebrowser
    signal-desktop
    skypeforlinux
    smem
    stack
    sqlite
    sysdig
    sysstat
    tcpdump
    tmux
    thunderbird
    tlp
    tlaplusToolbox
    texlive.combined.scheme-full
    traceroute
    unzip
    usbutils # for lsusb
    valgrind
    vim
    vscode
    wget
    wireshark
    whois
    xclip
    xfce.xfce4-pulseaudio-plugin
    yewtube
    youtube-dl
    zathura
    zip
    zsh
    zulip
  ];

  environment.localBinInPath = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

  # systemd timers
  # systemd.timers."sync-gtd-org" = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnBootSec = "5m";
  #     OnUnitActiveSec = "5m";
  #     Unit = "sync-gtd-org.service";
  #   };
  # };

  systemd.timers."sync-gtd-org" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "sync-gtd-org.service";
    };
  };


  systemd.services."sync-gtd-org" = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.rsync}/bin/rsync ~/Nextcloud/org/gtd.org ~/Nextcloud/org/sync/gtd.org
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pt";
    };

  };

  systemd.timers."scrape-phone-prices" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30m";
      OnUnitActiveSec = "30m";
      Unit = "scrape-phone-prices.service";
    };
  };

  systemd.services."scrape-phone-prices" = {
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.nix
      pkgs.bash
      pkgs.scrot      
      (pkgs.python3.withPackages (ps: with ps; [
        numpy
        requests
        beautifulsoup4
        pyautogui              
      ]))
    ];
    script = ''
       python3 /home/pt/repos/phone-prices/scrape-phone-prices.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pt";
    };
  };

  system.activationScripts.binbash = {
    deps = [ "binsh" ];
    text = ''
         ln -s /bin/sh /bin/bash
    '';
  };

  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
