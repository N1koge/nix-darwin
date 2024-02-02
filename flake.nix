{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin":
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs };
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = [];

      services.nix-daemon.enable = true;
      
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      system.configurationRevision = "dirty";

      system.stateVeresion = 4;

      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.shellAliases = {
        nds = "nix run nix-darwin -- switch --flake ~/.config/nix-darwin";
      };

      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;
      system.defaults.dock = {
        orientation = "left";
        show-recents = false;
        tilesize = 48;
      };

      fonts = {
        fontDir.enable = true;
      };

      homebrew = {
        enable = true;
        casks = [
          "brave-browser"
          "raycast"
        ];
      };
    };
  in 
  {
    darwinConfigurations."" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    darwinPackages = self.darwinConfigurations."".pkgs;
  };
}
