#!/bin/sh

envFilename='.env.local'
nextFolder='./.next/'

apply_path() {
  while IFS= read -r line; do
    if [ "${line:0:1}" = "#" ] || [ -z "$line" ]; then
      continue
    fi

    configName="$(echo "$line" | cut -d'=' -f1)"
    configValue="$(echo "$line" | cut -d'=' -f2)"
    envValue=$(env | grep "^$configName=" | grep -oe '[^=]*$')

    if [ -n "$configValue" ] && [ -n "$envValue" ]; then
      find "$nextFolder" \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i "s#$configValue#$envValue#g"
    fi
  done < "$envFilename"
}

apply_path
echo "Starting Nextjs"
exec "$@"
