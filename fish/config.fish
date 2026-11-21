set -U fish_greeting

if status is-interactive
    function ss --description "Custom one-line pacman search with version"
        if test (count $argv) -eq 0
            echo "Use : ss <package-name>"
            return 1
        end

        pacman -Ss $argv 2>/dev/null | awk '
        BEGIN {
            while (("pacman -Qq" | getline inst_pkg) > 0) {
                installed[inst_pkg] = 1
            }
            close("pacman -Qq")
            print "----------------------------------------------------------------------------------------------------"
        }
        /^[^ ]/ {
            # Memisahkan repo/nama_paket dan mengambil nama paketnya saja
            split($1, repo_pkg, "/")
            pkg = repo_pkg[2]
            ver = $2
            
            # Mengambil deskripsi di baris berikutnya
            getline desc
            sub(/^[ \t]+/, "", desc)

            if (pkg in installed) {
                printf "\033[1;32m%-15s\033[0m \033[1;36m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[installed]", pkg, "(" ver ")", desc
            } else {
                printf "\033[0;90m%-15s\033[0m \033[1;37m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[not installed]", pkg, "(" ver ")", desc
            }
        }
        END {
            print "----------------------------------------------------------------------------------------------------"
        }'
    end

    # Singkatan (Abbreviations) untuk Pacman
    abbr -a si "sudo pacman -S"
    abbr -a srm "sudo pacman -Rns"
    function soo
        set orphans (pacman -Qdtq)
        if test -n "$orphans"
            echo "Orphans found:" $orphans
            sudo pacman -Rs $orphans
        else
            echo "System is clean—no orphan packages found."
        end
    end
    
    # Singkatan lainnya tetap sama
    abbr -a cmt "$HOME/dotfiles/scripts/commit"
    abbr -a vs "code -r ."
end

set -gx PATH "$HOME/.cargo/bin" \
    "$HOME/.local/share/pnpm/bin" \
    "$HOME/.local/bin" \
    $PATH
