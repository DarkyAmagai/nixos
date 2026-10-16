{ pkgs, ... }:
let
    # Comando para gestionar /etc/hosts rápidamente en labs (HTB, etc.).
    # En NixOS /etc/hosts es un symlink de solo lectura al store; la primera
    # edición lo convierte en un archivo mutable conservando su contenido.
    # Un `nixos-rebuild` lo restaura al estado declarativo (se re-añaden las
    # entradas efímeras del lab, que es justo lo que queremos).
    htb-host = pkgs.writeShellScriptBin "htb-host" ''
        set -euo pipefail
        HOSTS=/etc/hosts
        SED=${pkgs.gnused}/bin/sed
        GREP=${pkgs.gnugrep}/bin/grep

        usage() {
            echo "Gestiona /etc/hosts para labs (HTB)."
            echo
            echo "Uso:"
            echo "  htb-host <ip> <nombre> [nombre2 ...]   añade o actualiza una entrada"
            echo "  htb-host -r <nombre> [nombre2 ...]      elimina por nombre"
            echo "  htb-host -l                            lista las entradas"
            echo
            echo "Ejemplos:"
            echo "  htb-host 10.129.74.59 touch.htb"
            echo "  htb-host 10.10.11.50 dev.htb api.dev.htb"
            echo "  htb-host -r touch.htb"
        }

        ensure_mutable() {
            if [ -L "$HOSTS" ]; then
                real=$(readlink -f "$HOSTS")
                sudo cp --remove-destination "$real" "$HOSTS"
                sudo chmod 644 "$HOSTS"
            fi
        }

        reesc() { printf '%s' "$1" | "$SED" 's/[][\.*^$/]/\\&/g'; }

        remove_names() {
            for n in "$@"; do
                e=$(reesc "$n")
                sudo "$SED" -i "/[[:space:]]''${e}\([[:space:]]\|$\)/d" "$HOSTS"
            done
        }

        case "''${1:-}" in
            -l|--list)
                "$GREP" -vE '^[[:space:]]*#|^[[:space:]]*$' "$HOSTS" ;;
            -r|--remove)
                shift; [ $# -ge 1 ] || { usage; exit 1; }
                ensure_mutable; remove_names "$@"
                echo "Eliminado: $*" ;;
            ""|-h|--help)
                usage ;;
            *)
                ip="$1"; shift
                [ $# -ge 1 ] || { usage; exit 1; }
                echo "$ip" | "$GREP" -qE '^[0-9a-fA-F:.]+$' || { echo "IP inválida: $ip" >&2; exit 1; }
                ensure_mutable; remove_names "$@"
                printf '%s %s\n' "$ip" "$*" | sudo tee -a "$HOSTS" >/dev/null
                echo "Añadido: $ip $*" ;;
        esac
    '';
in
{
    environment.systemPackages = [ htb-host ];
}
