{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        john
        hashcat
        hashcat-utils
        hydra
        thc-hydra
        hashid
        hash-identifier
        ophcrack
        # Generación/mutación de diccionarios
        crunch
        cewl
        # Añadidos del kit (verificados en nixpkgs aarch64)
        medusa
        ncrack
    ];
}
