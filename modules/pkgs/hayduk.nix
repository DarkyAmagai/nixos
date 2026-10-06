{ stdenvNoCC, fetchurl, autoPatchelfHook, lib }:

stdenvNoCC.mkDerivation rec {
    pname = "hayduk";
    version = "0.1.5";

    src = fetchurl {
        url = "https://github.com/jolovicdev/hayduk/releases/download/v${version}/hayduk_${version}_linux_arm64.tar.gz";
        hash = "sha256-rCAgogVe/3+73PsNRMYj49+vIdWTKTTOhx8+hrsTwFQ=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [ autoPatchelfHook ];

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        install -m755 hayduk $out/bin/hayduk
        runHook postInstall
    '';

    meta = {
        description = "Graphic console metasploit gestion";
        homepage = "https://github.com/jolovicdev/hayduk";
        license = lib.licenses.mit;
        platforms = [ "aarch64-linux"];
        mainProgram = "hayduk";
    };
}
