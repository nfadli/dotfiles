set -U fish_greeting
if status is-interactive
    function ss --description "Custom one-line apt search with version"
        if test (count $argv) -eq 0
            echo "Use : ss <package-name>"
            return 1
        end

        apt-cache search $argv | sort | awk '
        BEGIN {
            print "----------------------------------------------------------------------------------------------------"
        }
        {
            pkg = $1
            desc = $0
            sub(/^[^ ]+ - /, "", desc)

            # Ambil versi dari apt-cache policy
            ver = "N/A"
            cmd_ver = "LANG=C apt-cache policy " pkg " 2>/dev/null"
            while ((cmd_ver | getline line) > 0) {
                if (line ~ /Candidate:/) {
                    ver = line
                    sub(/.*Candidate:[ \t]+/, "", ver)
                    break
                }
            }
            close(cmd_ver)

            # Cek status instalasi lewat dpkg-query
            is_inst = 0
            status = ""
            cmd_inst = "dpkg-query -W -f=\x27${Status}\x27 " pkg " 2>/dev/null"
            cmd_inst | getline status
            close(cmd_inst)
            if (status ~ /install ok installed/) {
                is_inst = 1
            }

            if (is_inst) {
                printf "\033[1;32m%-15s\033[0m \033[1;36m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[installed]", pkg, "(" ver ")", desc
            } else {
                printf "\033[0;90m%-15s\033[0m \033[1;37m%-25s\033[0m \033[0;33m%-18s\033[0m : %s\n", "[not installed]", pkg, "(" ver ")", desc
            }
        }
        END {
            print "----------------------------------------------------------------------------------------------------"
        }'
    end

    abbr -a si "sudo apt install"
    abbr -a srm "sudo apt autoremove --purge"
    abbr -a soo "sudo apt autoremove --purge && sudo apt clean"
    abbr -a sup "sudo apt update && sudo apt upgrade"

    abbr -a cmt "$HOME/dotfiles/scripts/commit"
    abbr -a vs "code -r ."
end
set -gx PATH "$HOME/.cargo/bin" \
    "$HOME/.local/share/pnpm/bin" \
    "$HOME/.local/bin" \
    $PATH
