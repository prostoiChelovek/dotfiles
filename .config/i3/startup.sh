#!/bin/bash

i3-msg "workspace 2:chrome"
sleep 0.1
# i3-msg "exec --no-startup-id google-chrome-stable notion.so && google-chrome-stable https://pizzabot.atlassian.net/jira/software/projects/PB/boards/1"
i3-msg "exec --no-startup-id google-chrome-stable"
sleep 0.5

i3-msg "workspace 3:social"
sleep 0.1
i3-msg "layout tabbed"
sleep 0.1

i3-msg "workspace 4:obsidian"
sleep 0.1
i3-msg "exec --no-startup-id obsidian"
sleep 1

i3-msg "workspace 1:vim"

