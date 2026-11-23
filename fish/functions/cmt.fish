function cmt
    if test (count $argv) -lt 2
        echo "Invalid usage! Format: cmt <type> <commit message>"
        echo "Example: cmt feat add user login"
        return 1
    end

    set first_word $argv
    set rest_words $argv[2..-1]
    set commit_msg "($first_word) $rest_words"

    echo "🚀 Commit message: $commit_msg"
    git add .
    and git commit -m "$commit_msg"
    and git push
end
