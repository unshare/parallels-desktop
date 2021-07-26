#!/bin/bash

############################################################
# Copyright (c) 2004-2014 Parallels International GmbH.
# All rights reserved.
# http://www.parallels.com
############################################################


TOOLS_DIR="/usr/lib/parallels-tools"
BACKUP_DIR="/var/lib/parallels-tools"

E_NOERR=0
E_NOXSERV=163

prl_check_version()
{
	local xorg_version
	xorg_version=$("$TOOLS_DIR/installer/detect-xserver.sh" --xver)
	case $? in
		$E_NOERR|$E_NOXSERV) ;;
		*)
			echo "Error: Can't detect Xorg server version, exitting" >&2
			exit 1
	esac
	[[ ! -r "$BACKUP_DIR/xorg.version" ]] && return 2
	local xorg_old_version=$([ -r "$BACKUP_DIR/xorg.version" ] &&
		cat "$BACKUP_DIR/xorg.version")
	[[ -z "$xorg_version" ]] && [[ -z "$xorg_old_version" ]] && return 0
	[[ "$xorg_old_version" != "$xorg_version" ]] && return 2
	return 0
}

prl_install_xorg()
{
	"$TOOLS_DIR/install" --install-x-modules
}

# Check options passed in.
check_opts()
{
	for ARG in "$@"
	do
		case $ARG in
			-i)
				prl_check_version
				result=$?
				[ $result -eq 2 ] && prl_install_xorg && exit $?
				exit $result
				;;
			*)
				echo "Not valid argument was sent."
				exit 3
				;;
		esac
	done
}

if [ "$#" -eq "0" ]; then
	echo "No arguments specified"
else
	check_opts "$@"
fi

exit 0
