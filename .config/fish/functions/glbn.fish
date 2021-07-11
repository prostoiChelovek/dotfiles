function glbn
    echo (git branch -r | sed "s/origin\///g" | awk '{$1=$1};1' | grep -o -E "^[0-9]+" | awk '!seen[$0]++' | sort -n | tail -n 1)
end

