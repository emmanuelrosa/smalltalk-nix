{
  description = "Smalltalk virtual machine packages for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages."${system}";
    in {
        opensmalltalk-vm-cog-spur-5_0 = pkgs.callPackage ./pkgs/opensmalltalk-vm {
            version = "5.0";
            release = "202312181441";
            branding = "squeak";
            vmType = "cog";
            memoryManager = "spur";
            os = "linux";
            wordsize = "64";
            arch = "64";
        };
    };

  };
}
