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

# sleep 5

launch "2:chrome" "chrome" "google-chrome-stable"
launch "3:social" "social" "/home/chelovek/.config/i3/social.sh"

# sleep 10
# 
# i3-msg "workspace 2:chrome"
# sleep 1
# # i3-msg "exec --no-startup-id google-chrome-stable notion.so && google-chrome-stable https://pizzabot.atlassian.net/jira/software/projects/PB/boards/1"
# i3-msg "exec --no-startup-id google-chrome-stable"
# sleep 7
# 
# i3-msg "workspace 3:social"
# sleep 1
# i3-msg "layout tabbed"
# sleep 1
# 
# i3-msg "workspace 1:vim"
# 
# activeworkspace=$(i3-msg -t get_workspaces | jq -c '.[] | select(.focused) | .name' --raw-output)
# atom &
# windowname=atom
# xprop -spy -root _NET_ACTIVE_WINDOW | \
#   while read line ; do 
#       if xprop WM_CLASS -id ${line##* } | grep -q $windowname ; then
#           i3-msg move "[con_id=\"${line##* }\"] to workspace " $activeworkspace
#           exit
#       fi
#   done
