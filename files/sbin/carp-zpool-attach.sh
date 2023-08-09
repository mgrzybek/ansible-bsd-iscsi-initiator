#! /bin/sh -e

logger "starting attaching the zpools"

zpool import -a
service ctld onestart

logger "done"