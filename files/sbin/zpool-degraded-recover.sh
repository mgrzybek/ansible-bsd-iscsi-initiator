#! /bin/sh

DEVICE=$1

logger "starting zpool recovery using $DEVICE"

for pool in $(zpool list | awk '/DEGRADED/ {print $1}') ; do
	for dev in $(zpool status $pool | awk '/REMOVED/ {print $1}') ; do
		if [ "$DEVICE" = "$dev" ] ; then
			logger "set $dev online for zpool $pool"
			zpool online $pool $dev
		fi
	done
done

for pool in $(zpool list | awk '/SUSPENDED/ {print $1}') ; do
	logger "clearing zpool $pool"
	zpool clear $pool
	logger "scrubing zpool $pool"
	zpool scrub $pool
done

logger "done"