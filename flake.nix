{
  description = "Nix packaged dell r710 fan control";

  outputs = { self, nixpkgs }:
  let

    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

  in {

    packages.${system} = {
      dell-fan-control = pkgs.callPackage ./package.nix {};
      default = self.packages.x86_64-linux.dell-fan-control;
    };

    nixosModules = {
      dell-fan-control = import ./module.nix;
      default = self.nixosModules.dell-fan-control;
    };
  };
}
