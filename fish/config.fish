set -U fish_greeting

if status is-interactive
    function ss --description "Custom one-line dnf search with version"
        if test (count $argv) -eq 0
            echo "Use : ss <package-name>"
            return 1
        end

        # Tambahan \n pada queryformat agar setiap paket dicetak di baris baru
        dnf repoquery --qf "%{name}|%{version}-%{release}|%{summary}\n" "*$argv*" 2>/dev/null | sort -u | awk -F'|' '
        BEGIN {
            while (("rpm -qa --qf \"%{NAME}\n\"" | getline inst_pkg) > 0) {
                installed[inst_pkg] = 1
            }
            close("rpm -qa --qf \"%{NAME}\n\"")
            print "----------------------------------------------------------------------------------------------------"
        }
        NF >= 3 {
            pkg = $1
            ver = $2
            desc = $3

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

    # Singkatan (Abbreviations) untuk DNF
    abbr -a di "sudo dnf install"
    abbr -a drm "sudo dnf remove"
    abbr -a doo "sudo dnf autoremove"
    
    # Singkatan lainnya tetap sama
    abbr -a cmt "$HOME/dotfiles/scripts/commit"
    abbr -a vs "code -r ."
end

set -gx PATH "$HOME/.cargo/bin" \
    "$HOME/.local/share/pnpm/bin" \
    "$HOME/.local/bin" \
    $PATH
