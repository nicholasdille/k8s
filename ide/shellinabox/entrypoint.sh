#!/bin/bash
set -e

test -n "${USERNAME}"
test -n "${PASSWORD}"

useradd --create-home --shell /bin/bash ${USERNAME}

( echo "${PASSWORD}"; echo "${PASSWORD}" ) | passwd ${USERNAME}

exec shellinaboxd "$@"