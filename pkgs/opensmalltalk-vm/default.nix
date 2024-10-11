{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsa-lib
, libpulseaudio
, sndio
, nas
, freetype
, glib
, glibc
, gnugrep
, libtool
, libuuid
, openssl
, pango
, xorg
, harfbuzz
, cairo
, libGL
, version ? null
, release ? null
, branding ? "squeak"
, vmType ? "cog"
, memoryManager ? "spur"
, os ? "linux"
, wordsize ? "64"
, arch ? "64"
}: let
    checksums = {
        "squeak-cog-spur-linux-64x64" = "1sr3hx2bp8wasi6dirqb5912d9smbwcb25hwxkfcyy2hdkp4v951";
    };
in stdenv.mkDerivation rec {
    inherit version release;
    pname = "opensmalltalk-vm";
    name = if version == null || release == null then (abort "opensmalltalk-vm: The `version` and `release` attributes are required.") else "${pname}-${version}-${release}";

    src = fetchurl {
        url = "https://github.com/OpenSmalltalk/${pname}/releases/download/${release}/${branding}.${vmType}.${memoryManager}_${os}${wordsize}x${arch}.tar.gz";
        sha256 = checksums."${branding}-${vmType}-${memoryManager}-${os}-${wordsize}x${arch}";
    };

    nativeBuildInputs = [
        autoPatchelfHook
    ];

    buildInputs = [
        xorg.libXext
        xorg.libX11
        xorg.libSM
        xorg.libICE
        xorg.libXrender
        alsa-lib
        libpulseaudio
        harfbuzz
        cairo
        libGL
        pango
        sndio
        nas
    ];

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib/${pname}
        
        cp -r lib/${branding}/${version}-${release}-${arch}bit/* $out/lib/${pname}/
        ln -s $out/lib/${pname}/squeak $out/bin/${pname}
    '';

    meta = with lib; {
      description = "Squeak virtual machine";
      homepage = "https://opensmalltalk.org/";
      license = with licenses; [ asl20 mit ];
      maintainers = with lib.maintainers; [ emmanuelrosa ];
      platforms = [ "x86_64-linux" ];
    };
}
