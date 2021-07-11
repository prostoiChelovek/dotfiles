function mkbranch
    set num (gnbn)
    read -l -P "Name: " name
    set name (string join "-" $num $name)
    echo "Branch name: $name"
    if ask-confirmation
        git checkout -b $name
        git push --set-upstream origin $name
    end
end
