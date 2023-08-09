#! /bin/sh

logger "starting detaching the zpools"

service ctld onestop

for pool in NAME
pool0 ; do
	zpool export 
done

logger "done"