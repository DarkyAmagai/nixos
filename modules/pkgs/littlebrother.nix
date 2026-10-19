{ stdenvNoCC, fetchFromGitHub, python3, makeWrapper, lib }:

let
    py = python3.withPackages (ps: with ps; [
        requests
        beautifulsoup4
        terminaltables
        exifread
        colorama
    ]);
in
stdenvNoCC.mkDerivation {
    pname = "littlebrother";
    version = "unstable-2021-02-20";

    src = fetchFromGitHub {
        owner = "lulz3xploit";
        repo = "LittleBrother";
        rev = "338cf821c3e051deedef1cbcf5f516dfef385a84";
        hash = "sha256-l7TEqyWluFkWmI7N9Y/0Ts+vtKN4/TKWKxrBQ1JgJRo=";
    };

    nativeBuildInputs = [ makeWrapper ];
    dontBuild = true;

    # El script importa de lib/, core/, txt/ y settings relativos a su carpeta,
    # así que se ejecuta con --chdir a su propio directorio en el store.
    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/littlebrother $out/bin
        cp -r . $out/share/littlebrother/
        makeWrapper ${py}/bin/python $out/bin/littlebrother \
            --add-flags "$out/share/littlebrother/LittleBrother.py" \
            --chdir "$out/share/littlebrother"
        runHook postInstall
    '';

    meta = {
        description = "Herramienta OSINT para recopilar información sobre personas";
        homepage = "https://github.com/lulz3xploit/LittleBrother";
        license = lib.licenses.gpl3Only;
        mainProgram = "littlebrother";
        platforms = lib.platforms.linux;
    };
}
