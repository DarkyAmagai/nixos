{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # Ingeniería inversa / binarios
        ghidra
        radare2
        rizin
        cutter
        gdb
        gef
        ltrace
        strace
        patchelf
        # Análisis de archivos / carving
        binwalk
        foremost
        scalpel
        file
        exiftool
        # Memoria / disco
        volatility3
        sleuthkit
        testdisk
        # Esteganografía
        steghide
        stegseek
        zsteg
        # CTF / cripto
        hashcat
        openssl
    ];
}
