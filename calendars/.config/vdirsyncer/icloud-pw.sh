#!/bin/sh
# Print the iCloud CalDAV app-specific password from ~/.authinfo.gpg.
gpg -q --for-your-eyes-only --no-tty -d "$HOME/.authinfo.gpg" 2>/dev/null \
| awk '/machine caldav.icloud.com/{for(i=1;i<=NF;i++) if($i ~ /^password$/) print $(i+1)}'
