# @yuetan uses this machine as a testbed for securefaas project

{ config, pkgs, ... }:

let
  hostname = "sns44";
  common = (import ./common.nix) { hostname = hostname; };
  utils = import ../utils;
  snapfaasSrc = pkgs.fetchFromGitHub {
    owner = "princeton-sns";
    repo = "snapfaas";
    rev = "61c4bff408adb466ee2714f9a0a82c25acf9bdf0";
    sha256 = "sha256-h0cJO/waluEkGEOku1MUPzRI6HvZlC/AkutgrT9NQW0=";
  };
  snapfaas = (import snapfaasSrc { inherit pkgs; release = false; }).snapfaas;
in {

  # Import common configurat for all machines (locale, SSHd, updates...)
  imports = [ common ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    snapfaas lkl lmdb python39Full e2fsprogs gnumake wget
    vim tmux
  ];

  # open up specified ports
  networking.firewall.allowedTCPPorts = [ 8888 ];

  programs.mosh.enable = true;

  virtualisation.docker.enable = true;

  users.users.yuetan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" ];	
    openssh.authorizedKeys.keys = utils.githubSSHKeys "tan-yue";
  };
  
  users.users.alevy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" ];	
    openssh.authorizedKeys.keys = utils.githubSSHKeys "alevy";
  };
  
  ## Kevin Wang (@kw1122) working on snapfaas grader over summer '22
  users.users.fierycandy = {
    isNormalUser = true;
    extraGroups = [ "kvm" ];
    openssh.authorizedKeys.keys = utils.githubSSHKeys "kw1122";
  };
}
