#!/bin/sh
bfile=$1
lfile=$extract/${bfile#$staging/}
RH_lfile=`dirname $lfile`/RH2m.`basename $lfile`
dname=`dirname $lfile`
[ -d $dname ] || mkdir -p $dname

if [ ! -s $lfile ]
then
    /Data/data20/tippett/scripts/wgrib2 -v0 $bfile -match "^(1|146.1|146.2|191.1|191.2|272.1|272.2|223|190|186|267|332|333|339|340|341|345|346|378|379)": -grib_out $lfile &> /dev/null
    /Data/data20/tippett/scripts/wgrib2 -v0 $bfile -match "^(331)": -grib_out $RH_lfile &> /dev/null
#    /usr/local/bin/wgrib2 -v0 $bfile -match "^(1|146.1|146.2|191.1|191.2|272.1|272.2|223|190|186|267|332|333|339|340|341|345|346|378|379)": -grib_out $lfile &> /dev/null
#    /usr/local/bin/wgrib2 -v0 $bfile -match "^(331)": -grib_out $RH_lfile &> /dev/null
#    echo -n 'p'
fi


# 1:0:d=2012120200:PRES Pressure [Pa]:mean sea level:1242 hour fcst:
# 146.1:5755459:d=2012120200:UGRD U-Component of Wind [m/s]:250 mb:1242 hour fcst:
# 146.2:5755459:d=2012120200:VGRD V-Component of Wind [m/s]:250 mb:1242 hour fcst:
# 191.1:8100355:d=2012120200:UGRD U-Component of Wind [m/s]:500 mb:1242 hour fcst:
# 191.2:8100355:d=2012120200:VGRD V-Component of Wind [m/s]:500 mb:1242 hour fcst:
# 272.1:12896737:d=2012120200:UGRD U-Component of Wind [m/s]:850 mb:1242 hour fcst:
# 272.2:12896737:d=2012120200:VGRD V-Component of Wind [m/s]:850 mb:1242 hour fcst:
# 223:10026216:d=2012120200:TMP Temperature [K]:700 mb:1242 hour fcst:
# 190:8024669:d=2012120200:VVEL Vertical Velocity (Pressure) [Pa/s]:500 mb:1242 hour fcst:
# 186:7857540:d=2012120200:HGT Geopotential Height [gpm]:500 mb:1242 hour fcst:
# 267:12658121:d=2012120200:HGT Geopotential Height [gpm]:850 mb:1242 hour fcst:
# 332:16453793:d=2012120200:APCP Total Precipitation [kg/m^2]:surface:1236-1242 hour acc fcst:
# 333:16492559:d=2012120200:ACPCP Convective Precipitation [kg/m^2]:surface:1236-1242 hour acc fcst:
# 339:16555268:d=2012120200:LFTX Surface Lifted Index [K]:surface:1242 hour fcst:
# 340:16583754:d=2012120200:CAPE Convective Available Potential Energy [J/kg]:surface:1242 hour fcst:
# 341:16617694:d=2012120200:CIN Convective Inhibition [J/kg]:surface:1242 hour fcst:
# 345:16711456:d=2012120200:HLCY Storm Relative Helicity [m^2/s^2]:3000-0 m above ground:1242 hour fcst:
# 346:16752083:d=2012120200:HLCY Storm Relative Helicity [m^2/s^2]:1000-0 m above ground:1242 hour fcst:
# 378:18858545:d=2012120200:CAPE Convective Available Potential Energy [J/kg]:180-0 mb above ground:1242 hour fcst:
# 379:18892931:d=2012120200:CIN Convective Inhibition [J/kg]:180-0 mb above ground:1242 hour fcst:
# 331:16287428:d=2013042400:RH:2 m above ground:2376 hour fcst:
#
