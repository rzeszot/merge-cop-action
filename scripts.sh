#!/bin/bash

set -uo pipefail

action_path=`dirname "$0"`
exit_code=0

for script in "$action_path"/scripts.d/*.sh
do
    . $script

    if [ "$$?" -ne 0 ]; then
        exit_code=1
    fi
done

exit $exit_code
