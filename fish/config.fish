if status is-interactive
fish_add_path -g "$HOME/.local/share/pnpm/bin"
end
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
