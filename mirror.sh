#!/bin/sh

export MAILTO="mkt14@columbia.edu"
export staging=/Data/data20/tippett/cfs
export staging_new=/Data/data20/tippett/cfs
export extract=/Data/data20/tippett/cfs_ext
scriptdir=/Data/data20/tippett/scripts

# temporarily set umask so group permissions are writable
umask 0002

echo -e 'Starting at\t\t' `date`

lftp_xfer_log="$scriptdir/cfs_transfer_log.$$"
xfer_ed="$scriptdir/transfered_files.$$"

#$scriptdir/new_lftp_src/bin/lftp -e "set xfer:log true ; set xfer:log-file $lftp_xfer_log ; set net:limit-total-rate 1048576 ; mirror --parallel=1  --use-cache --only-missing -i pgbf* -i flxf* -x monthly* -x time_grib* -x p*.idx -x f*.idx https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/ $staging/ ; bye" 

# pgbf ONLY at higher speed
#$scriptdir/new_lftp_src/bin/lftp -e "set xfer:log true ; set xfer:log-file $lftp_xfer_log ; set net:limit-total-rate 10485760 ; mirror --parallel=1  --use-cache --only-missing -i pgbf* -x monthly* -x time_grib* -x p*.idx -x f*.idx https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/ $staging/ ; bye" 

# flxf ONLY at higher speed
#$scriptdir/new_lftp_src/bin/lftp -e "set xfer:log true ; set xfer:log-file $lftp_xfer_log ; set net:limit-total-rate 2097152 ; mirror --parallel=1  --use-cache --only-missing -i flxf* -x monthly* -x time_grib* -x p*.idx -x f*.idx https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs/ $staging/ ; bye" 

#$scriptdir/lftp_src/bin/lftp -e "set ftp:sync-mode off ; set xfer:log true ; set xfer:log-file $lftp_xfer_log ; mirror --only-missing -i pgbf* -i flxf* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/cfs/ $staging/ ; bye" ftp.ncep.noaa.gov

# GOOD ONE for now NOT GOOD NOW June 28, 2022. Directory has changed.
# when the directory changes (one less level) perhaps ADD exclude cdas -x cdas*
# $scriptdir/lftp_src/bin/lftp -e "set ftp:sync-mode off ; set xfer:log true ; set xfer:log-file $lftp_xfer_log ; mirror --parallel=10 --only-missing -i pgbf* -i flxf* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/cfs/ $staging/ ; bye" ftp.ncep.noaa.gov

# without the extra cfs this works for one day at a time now 
# $scriptdir/lftp_src/bin/lftp -e "set ftp:sync-mode off ; set xfer:log true ; set xfer:log-file $lftp_xfer_log ; mirror --parallel=10 --only-missing -i pgbf* -i flxf* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/cfs.20220628/ $staging/ ; bye" ftp.ncep.noaa.gov

# NEW ONE starting June 28, 2022. Directory has changed. AND there are cdas files that I do not want
# REMOVED a dir level and ADDED: -x cdas* -x cfs
# $scriptdir/lftp_src/bin/lftp -e "set ftp:sync-mode off ; set xfer:log true ; set xfer:log-file $lftp_xfer_log ; mirror --parallel=10 --only-missing -i pgbf* -i flxf* -x cfs -x cdas* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/ $staging/ ; bye" ftp.ncep.noaa.gov
$scriptdir/lftp_src/bin/lftp -e "set ftp:sync-mode off ; set xfer:log true ; set xfer:log-file $lftp_xfer_log ; mirror --parallel=10 --only-missing -i pgbf* -i flxf* -x /pub/data/nccf/com/cfs/prod/cfs/* -x cfs/cfs -x cfs.20220601 -x cfs.20220602 -x cfs.20220614 -x cfs.20220615 -x cdas* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/ $staging_new ; bye" ftp.ncep.noaa.gov

#echo 'removing /Data/data20/tippett/cfs/cfs'
#rmdir /Data/data20/tippett/cfs/cfs

echo -e 'lftp finished at\t' `date`

if [ -a $lftp_xfer_log ] 
then
    awk '{print $5}' $lftp_xfer_log > $xfer_ed
    
    N=`grep -c pgbf $xfer_ed`
    echo $N 'PBGF files transfered'
    if [ "$N" -gt "0" ] 
    then
	grep pgbf $xfer_ed | xargs -n 1 sh $scriptdir/extract_pgbf_new.sh
	echo
    fi	
    N=`grep -c flxf $xfer_ed`
    echo $N 'FLXF files transfered'
    if [ "$N" -gt "0" ] 
    then
	grep flxf $xfer_ed | xargs -n 1 sh $scriptdir/extract_flxf_new.sh
	echo
    fi
	
else
    echo 'No new files'
fi

echo 'wgrib2 finished at' `date`

/bin/rm $lftp_xfer_log $xfer_ed

#for ii in `seq 1 4` ;
#do
#    find $staging -mtime -1 -wholename *6hrly_grib_0$ii* -name pgbf*.grb2 -exec sh $scriptdir/extract_pgbf_new.sh '{}' \;
#    find $staging -mtime -1 -wholename *6hrly_grib_0$ii* -name flxf*.grb2 -exec sh $scriptdir/extract_flxf_new.sh '{}' \; 
#done


echo 'Extracted'
sh $scriptdir/make_filenames_extract.sh 

echo
echo 'Unextracted'
sh $scriptdir/make_filenames.sh | tail -10

find $staging -mtime +14 -type f  -delete
find $staging -maxdepth 3 -mtime +7 -type d -empty -delete
#echo "Don't forget to turn the cleanup back on!"

#curl -s -o /dev/null http://iridl.ldeo.columbia.edu/expert/home/.tippett/.CFS/.KAU/.PRATE_INDEX/gridtable.tsv

echo -e 'Finished at\t\t' `date`
