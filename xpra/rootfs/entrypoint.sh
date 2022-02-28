#!/usr/bin/env sh
cd /home/xpra_user
exec /init s6-setuidgid xpra_user "$@"
