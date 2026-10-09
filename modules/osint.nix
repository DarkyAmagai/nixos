{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        theharvester
        sherlock
        maigret
        holehe
        recon-ng
        exiftool
        yt-dlp
    ];
}
