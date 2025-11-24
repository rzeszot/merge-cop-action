#!/bin/bash

exit_code=0

normalize() {
    IFS='.' read -r a b c
    echo "${a:-0}.${b:-0}.${c:-0}"
}

echo "::group::Package version"

if [[ ! -f Package.swift ]]
then
    echo "::debug::Package.swift doesn't exist. Skipping all checks."
    echo "::endgroup::"
    exit 1
fi

package_swift=`swift package dump-package | jq -r '.toolsVersion._version' | normalize`

if [[ -f .swift-version ]]
then
    swift_version=`cat .swift-version | normalize`

    if [ "$package_swift" != "$swift_version" ]
    then
        echo "::error file=.swift-version,line=1::Version defined in .swift-version ($swift_version) is different from Package.swift ($package_swift)"
        exit_code=1
    fi
else
    echo "::debug::.swift-version doesn't exist. Skipping check."
fi

echo "::endgroup::"
exit $exit_code
