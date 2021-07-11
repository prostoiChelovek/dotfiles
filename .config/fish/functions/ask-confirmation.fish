function ask-confirmation
    # https://stackoverflow.com/a/16673745
    while true
        read -l -P 'Do you want to continue? [y/N] ' confirm

        switch $confirm
            case Y y
                return 0
            case '' N n
                return 1
        end
    end
end
