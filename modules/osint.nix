{ pkgs, ... }:
let
    littlebrother = pkgs.callPackage ./pkgs/littlebrother.nix { };
in
{
    environment.systemPackages = with pkgs; [
        # Personas / usuarios / correos
        sherlock          # nombres de usuario en cientos de sitios
        maigret           # perfiles por nombre de usuario (más amplio)
        holehe            # en qué sitios está registrado un email
        socialscan        # disponibilidad de email/usuario
        h8mail            # emails en filtraciones (breach hunting)
        ghunt             # OSINT sobre cuentas de Google
        littlebrother     # investigación de personas (empaquetado aparte)
        # Redes sociales
        instaloader       # scraping de Instagram
        snscrape          # scraping de redes (X, etc.)
        octosuite         # OSINT de GitHub
        # Dominios / infraestructura
        theharvester      # correos, subdominios, hosts
        recon-ng          # framework OSINT modular
        dnstwist          # typosquatting / dominios parecidos (phishing)
        photon            # crawler para recolección OSINT
        sn0int            # framework OSINT semiautomático
        # APIs de inteligencia (requieren API key)
        python3Packages.shodan
        python3Packages.censys
        # Utilidades
        exiftool          # metadatos de archivos/imágenes
        yt-dlp            # descarga de medios
    ];
}
