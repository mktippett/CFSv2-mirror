#!/bin/sh

bfile=$1
lfile=$extract/${bfile#$staging/}

dname=`dirname $lfile`
[ -d $dname ] || mkdir -p $dname

if [ ! -s $lfile ]
then
#    /usr/local/bin/wgrib2 -v0 $bfile -match "^(31|32|34|36.1|36.2|37|50):"  -grib_out $lfile &> /dev/null
    /Data/data20/tippett/scripts/wgrib2 -v0 $bfile -match "^(31|32|34|36.1|36.2|37|50):"  -grib_out $lfile &> /dev/null
#    echo -n 'f'
fi


# 31:1753916:d=2012120300:PRATE:surface:3948 hour fcst:
# 32:1792975:d=2012120300:CPRAT:surface:3948 hour fcst:
# 34:1845380:d=2012120300:LAND:surface:3948 hour fcst:
# 36.1:1862091:d=2012120300:UGRD:10 m above ground:3948 hour fcst:
# 36.2:1862091:d=2012120300:VGRD:10 m above ground:3948 hour fcst:
# 37:1982430:d=2012120300:TMP:2 m above ground:3948 hour fcst:
# 50:2566615:d=2012120300:PWAT:entire atmosphere (considered as a single layer):3948 hour fcst:
#
#


