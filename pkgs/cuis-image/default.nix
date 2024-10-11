{ stdenv
, lib
, fetchurl
, version ? null
, commit ? null
, hashes ? null
}: let
    baseUrl = "https://github.com/Cuis-Smalltalk/Cuis7-0/raw/${commit}";

    imageFile = fetchurl {
        url = "${baseUrl}/CuisImage/Cuis${version}.image";
        sha256 = hashes.imageFile;
    };

    sourcesFile = fetchurl {
        url = "${baseUrl}/CuisImage/Cuis${version}.sources";
        sha256 = hashes.sourcesFile;
    };

    changesFile = fetchurl {
        url = "${baseUrl}/CuisImage/Cuis${version}.changes";
        sha256 = hashes.changesFile;
    };

    mkSymlink = source: ''
        ln -s ${source} $out/$(basename ${source} | cut -d "-" -f 2)
    '';
in stdenv.mkDerivation {
    inherit version commit;
    pname = "cuis-image";
    src = ./.;

    installPhase = ''
        mkdir $out

        ${mkSymlink imageFile}
        ${mkSymlink sourcesFile}
        ${mkSymlink changesFile}
    '';

    meta = with lib; {
      description = "Cuis ${version} Smalltalk image";
      homepage = "https://cuis.st/";
      license = with licenses; [ mit ];
      maintainers = with lib.maintainers; [ emmanuelrosa ];
      platforms = [ "x86_64-linux" ];
    };
}
