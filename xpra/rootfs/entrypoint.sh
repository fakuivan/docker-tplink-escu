#!/usr/bin/env bash
exec /init s6-setuidgid xpra_user bash -c 'export HOME=~xpra_user && cd && "$@"' -- "$@"
