if status is-interactive
fish_add_path -g "$HOME/.local/share/pnpm/bin"
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "/home/linuxbrew/.linuxbrew/opt/rustup/bin"
abbr -a vs code -r .
end
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
