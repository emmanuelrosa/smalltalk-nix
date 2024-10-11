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

        cuis-image-7_0 = pkgs.callPackage ./pkgs/cuis-image {
            version = "7.0";
            commit = "7c5091fba8df3d4fb5d61f98e3d3aa1138fac17f";
            hashes = {
                imageFile = "sha256-rZAz7e7aP6pYQ59nGD41KNxCHDinrHl+hs/2BwrwZg4=";
                sourcesFile = "sha256-/1lcTPtLQocOjRQwFmjr6upON0DiG4m/vFum9x4AL1w=";
                changesFile = "sha256-aOofs1BZEk1P8/cYXDEA5iPipYKekskE7ycHKpQDb/U=";
            };
        };

        cuis-7_0 = pkgs.callPackage ./pkgs/cuis {
            version = "7.0";
            opensmalltalk-vm = self.packages."${system}".opensmalltalk-vm-cog-spur-5_0;
            smalltalkImage = self.packages."${system}".cuis-image-7_0;
            mimeInfoFile = ./mime/cuis.xml;
            mimeTypeFile = ./mime/x-smalltalk-image.xml;
        };
    };

  };
}
