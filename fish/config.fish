if status is-interactive
	# for debian
	abbr -a si "sudo apt install"
	abbr -a ss "apt-cache search --names-only"
	abbr -a srm "sudo apt purge --autoremove"
	abbr -a soo "sudo apt clean"
	abbr -a cmt "$HOME/dotfiles/commit"
	abbr -a vs "code -r ."
end
set -gx PATH "$HOME/.cargo/bin" \
            "$HOME/.local/share/pnpm/bin" \
            "$HOME/.local/bin" \
            $PATH
