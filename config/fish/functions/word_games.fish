function lookup -d "given a regex, show the words"
    rg ^$argv\$ /usr/share/dict/words
end

# TODO: no idea yet
function one-swap -d "for the given letters, print all words that are one edit away"
    for c in $argv
        echo $c
    end
end
