#!/bin/fish

function launch
    set layouts_dir "/home/chelovek/.config/i3/layouts"
    set start_workspace "1:vim"

    set workspace $argv[1]
    set layout_file "$layouts_dir/$argv[2].json"
    set app_name $argv[3]

    i3-msg "workspace $workspace; \
            append_layout $layout_file; \
            exec --no-startup-id $app_name &; \
            workspace $start_workspace"
end

launch "2:chrome" "chrome" "google-chrome-stable"
launch "3:social" "social" "/home/chelovek/.config/i3/social.sh"

