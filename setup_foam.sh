#!/bin/bash
#
# INSTRUCTIONS:
#
# - Save this file to ~/OpenFOAM/images/setup_foam.sh (if you choose a
#   different place, adjust the follwing instructions accordingly)
#
# - Adapt the lines in between the markers #### CONFIG #### and
#   #### END CONFIG #### to your setup. If you are unsure about the
#   architecture of your Mac, you can use the "arch" command. If it shows
#   "i386", use "darwinIntel64DPOpt", otherwise use "darwinPpcDPOpt". Make sure
#   the paths to the disk image files are correct!
#
# - Save and close the file.
#
# - Issue the following command:
#
#     cp ~/.bash_profile ~/.bash_profile.bak_setup_foam_$(date '+%Y%m%d%H%M%S')
#     echo "source ~/OpenFOAM/images/setup_foam.sh" >> ~/.bash_profile
#
# - Close and re-open Terminal.app
#
# - Every time you first want to use OpenFOAM (i.e. every time you open a new
#   shell window or tab) issue the following command:
#
#     setup_foam
#
# - And now you should be ready to use OpenFOAM.
#

# Copyright 2008-2010 Michael Wild

function setup_foam {

### CONFIG ###

# The OpenFOAM version you want to use
local OFVERSION=1.7.x

# The revision of the DMG file
local OFREVISION=2

# The architecture of your Mac (or rather of the disk image you downloaded)
local OFARCH=darwinIntel64DPOpt
#local OFARCH=darwinPpcDPOpt

# Path to the OpenFOAM disk image file. The $XXX variables will be replaced
# with above values.
local OFIMAGE=~/OpenFOAM/images/OpenFOAM-$OFVERSION-$OFREVISION-MacOSX-10.5-$OFARCH.dmg

# Path to the user's own disk image.
local OFUSERIMAGE=~/OpenFOAM/images/$LOGNAME-$OFVERSION.sparseimage

### END CONFIG ###

# sanity checks
for d in ~/OpenFOAM/OpenFOAM-$OFVERSION ~/OpenFOAM/$LOGNAME-$OFVERSION; do
  if [ -d $d -a $(ls $d 2>/dev/null | wc -l) -eq 0 ]; then
    echo "Error: The directory '$d'" >&2
    echo "exists, but is empty. It is likely that it" >&2
    echo "is a left-over from a crash, forced shutdown" >&2
    echo "or failed unmount. Make sure it doesn't" >&2
    echo "contain important (hidden) data and then" >&2
    echo "remove or rename it." >&2
    return 1
  fi
done
if [ ! -f $OFIMAGE ]; then
  echo "The OpenFOAM disk-image '$OFIMAGE' does not exist" >&2
  return 1
fi

if [ ! -f $OFUSERIMAGE ]; then
  echo "Creating user disk-image $OFUSERIMAGE"
  mkdir -p ${OFUSERIMAGE%/*}
  hdiutil create -size 1t -type SPARSE -fs HFSX \
    -volname "${LOGNAME}-${OFVERSION}" $OFUSERIMAGE
fi

if [ ! -d ~/OpenFOAM/OpenFOAM-$OFVERSION ]; then
  hdiutil attach -mountroot ~/OpenFOAM $OFIMAGE
fi
if [ ! -d ~/OpenFOAM/$LOGNAME-$OFVERSION ]; then
  hdiutil attach -mountroot ~/OpenFOAM $OFUSERIMAGE
fi

source ~/OpenFOAM/OpenFOAM-$OFVERSION/etc/bashrc
}
