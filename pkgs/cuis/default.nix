{ stdenv
, lib
, fetchurl
, writeScript
, runCommand
, bash
, coreutils
, zenity
, imagemagick
, mimeInfoFile
, mimeTypeFile
, version ? null
, opensmalltalk-vm ? null
, smalltalkImage ? null
, executableName ? null
}: let
    pname = "cuis";
    finalExecutableName = if executableName == null then (builtins.replaceStrings [ "." ] [ "_" ] "${pname}-${version}") else executableName;

    logo = fetchurl {
        url = "https://cuis.st/assets/imgs/CuisLogo-small.png";
        sha256 = "sha256-g8r2VhLSOzBEs/m7QljHpRQDDvvbQpTc0pPCAHZfLo8=";
    };

    icons = runCommand "${pname}-icons" {
        nativeBuildInputs = [ imagemagick ];
    } ''
        mkdir $out

        for n in 16 24 32 48 64 96 128 256; do
          size=$n"x"$n
          magick convert ${logo} -resize $size ${pname}.png
          install -Dm644 -t $out/hicolor/$size/apps ${pname}.png
        done;
    '';

    launcher = writeScript "${pname}-launcher" ''
        #! ${bash}/bin/bash

        PATH=${lib.makeBinPath [ coreutils zenity ]}

        args=$@

        if [ -n "$args" ]
        then
            ${opensmalltalk-vm}/bin/opensmalltalk-vm "$args"
        else
            CREATE_OPT="Create a new Cuis image"
            OPEN_OPT="Open an existing Cuis image"

            choice=$(zenity --list --title "Create or open a Cuis ${version} image" --radiolist --column Action --column "Description" TRUE "$CREATE_OPT" FALSE "$OPEN_OPT")

            if [ "$choice" == "$CREATE_OPT" ]
            then
                directory=$(zenity --file-selection --directory --title="Select where to save the Cuis image files")
                if [ -n "$directory" ]
                then
                    cp ${smalltalkImage}/* "$directory"
                    chmod u+w "$directory/Cuis${version}.image"
                    chmod u+w "$directory/Cuis${version}.changes"
                    chmod u+w "$directory/Cuis${version}.sources"

                    imagefile="$directory/Cuis${version}.image"
                    pushd $(dirname "$imagefile")
                    ${opensmalltalk-vm}/bin/opensmalltalk-vm "$imagefile"
                    popd
                fi
            fi

            if [ "$choice" == "$OPEN_OPT" ]
            then
                imagefile=$(zenity --file-selection --title="Select the Cuis image file")

                if [ -n "$imagefile" ]
                then
                    pushd $(dirname "$imagefile")
                    ${opensmalltalk-vm}/bin/opensmalltalk-vm "$imagefile"
                    popd
                fi
            fi
        fi
    '';
in stdenv.mkDerivation rec {
    inherit pname version;
    src = ./.;
    nativeBuildInputs = [ imagemagick ];

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/libexec
        mkdir -p $out/share/applications
        mkdir -p $out/share/mime/application
        mkdir -p $out/share/mime/packages

        ln -s ${launcher} $out/bin/${finalExecutableName}
        ln -s ${launcher} $out/libexec/launcher
        cp ./cuis.desktop $out/share/applications/

        substituteInPlace $out/share/applications/cuis.desktop --subst-var version --subst-var-by launcher $out/libexec/launcher

        ln -s ${mimeInfoFile} $out/share/mime/packages/cuis.xml
        ln -s ${mimeTypeFile} $out/share/mime/application/x-smalltalk-image.xml
        ln -s ${icons} $out/share/icons
    '';

    meta = with lib; {
      description = "Cuis Smalltalk ${version}";
      longDescription = "This is a Linux desktop integration package for Cuis Smalltalk, specifically for with NixOS. Install this package to easily create or open Cuis Smalltalk images from your application menu.";
      homepage = "https://github.com/emmanuelrosa/smalltalk-nix";
      license = with licenses; [ mit ];
      maintainers = with lib.maintainers; [ emmanuelrosa ];
      platforms = [ "x86_64-linux" ];
      mainProgram = finalExecutableName;
    };
}
