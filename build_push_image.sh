#!/usr/bin/env sh

MODULE="$1"

print_usage() {
	echo "This script is used as a backup to our currently automated build pipeline"
	echo
	echo "USAGE:"
	echo "  $0 [submodule_directory]"
	echo
	echo "This will run docker build in the specified directory"
	echo "  and then push the image with the specified tag."
}

set -e

if [ -z "$MODULE" ]; then
	print_usage
	exit 0
fi

printf "Enter image tag version: "
read -r REPLY

IMAGE_TAG="c5-docker-registry.events.cetrez.net/cetrez/code-workshop-django:$REPLY"

echo "Will use the following tag:"
echo "  $IMAGE_TAG"
echo

printf "Are you sure? (y/N): "
old_stty_cfg=$(stty -g)
stty raw -echo ; REPLY=$(head -c 1) ; stty "$old_stty_cfg" # Careful playing with stty
echo "$REPLY"
if echo "$REPLY" | grep -iq "^y" ;then
	set -x
	cd "$MODULE"
	docker build . -t "$IMAGE_TAG"
	docker push "$IMAGE_TAG"
fi
