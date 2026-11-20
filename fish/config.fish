set -U fish_greeting

if status is-interactive
    function ss --description "Custom one-line xbps search with version"
        if test (count $argv) -eq 0
            echo "Use : ss <package-name>"
            return 1
        end

        xbps-query -Rs "$argv" | sort | awk '
        BEGIN {
            print "----------------------------------------------------------------------------------------------------"
        }
        {
            # Format output bawaan xbps-query -Rs: "[*] nama-paket-1.2.3_1 Deskripsi paket"
            status_flag = $1
            pkg_ver = $2
            
            # Ambil deskripsi (hilangkan 2 kolom pertama)
            desc = $0
            sub(/^\[.\] [^ ]+ +/, "", desc)

            # Pisahkan nama paket dan versi (dipisahkan oleh tanda hubung terakhir)
            if (match(pkg_ver, /-[^-]+$/)) {
                pkg = substr(pkg_ver, 1, RSTART - 1)
                ver = substr(pkg_ver, RSTART + 1)
            } else {
                pkg = pkg_ver
                ver = "N/A"
            }

            # [*] artinya terinstal, [-] artinya belum terinstal
            if (status_flag == "[*]") {
                printf "\033[1;32m%-15s\033[0m \033[1;36m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[installed]", pkg, "(" ver ")", desc
            } else {
                printf "\033[0;90m%-15s\033[0m \033[1;37m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[not installed]", pkg, "(" ver ")", desc
            }
        }
        END {
            print "----------------------------------------------------------------------------------------------------"
        }'
    end

    # Singkatan (Abbreviations) untuk XBPS
    abbr -a si "sudo xbps-install -S"
    abbr -a srm "sudo xbps-remove -Ro"
    abbr -a soo "sudo xbps-remove -Oo"
    abbr -a sup "sudo xbps-install -Su"

    # Singkatan lainnya tetap sama
    abbr -a cmt "$HOME/dotfiles/scripts/commit"
    abbr -a vs "code -r ."
end

set -gx PATH "$HOME/.cargo/bin" \
    "$HOME/.local/share/pnpm/bin" \
    "$HOME/.local/bin" \
    $PATH
