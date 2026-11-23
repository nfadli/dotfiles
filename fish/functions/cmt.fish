function cmt
    read -P " Enter commit message: " -l input

    # Split input into words
    set words (string split " " (string trim "$input"))

    if test (count $words) -lt 2
        echo " Invalid input! Please enter at least 2 words (e.g., feat add user login)"
        return 1
    end

    set first_word $words[1]
    set rest_words $words[2..-1]
    set commit_msg "($first_word) $rest_words"

    # Stage all changes first
    git add .

    echo ""
    echo " Staged changes:"
    git status -s
    echo ""
    echo " Commit preview: $commit_msg"
    read -P " Proceed with commit and push? [y/N]: " -l confirm

    if string match -qi "y" "$confirm"
        git commit -m "$commit_msg"
        and git push
        and echo " Pushed successfully!"
    else
        git reset > /dev/null
        echo " Aborted. All staged files have been restored (unstaged)."
        return 1
    end
end
