{
  description = "xmoto-argocd-deployments";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/xmoto/k8s.agekey"
          '';

          packages = with pkgs; [
            age
            sops
            argocd
          ];
        };
      }
    );
}
