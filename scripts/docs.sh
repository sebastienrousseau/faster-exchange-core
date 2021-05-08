set -o errexit # Exit script as soon as a command fails.

# Check for 'uname' and abort if it is not available.
uname -v > /dev/null 2>&1 || { echo >&2 "ERROR - solidity requires 'uname' to identify the platform."; exit 1; }

# Get latest tag name
#latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
latestTag=$(git rev-parse --short HEAD)
versionNo=$(echo "$latestTag" | cut -b 2-6)

CORE_ROUTE=$PWD
OUTPUT_DIRECTORY="$PWD/docs/api"

mkdir -p "$OUTPUT_DIRECTORY"
# rm "$OUTPUT_DIRECTORY"/* 2> /dev/null

echo "Generating documentations in $OUTPUT_DIRECTORY"

"$CORE_ROUTE"/node_modules/solidoc/cli.js "$CORE_ROUTE" "$OUTPUT_DIRECTORY" en "$versionNo"

echo "Success!"
