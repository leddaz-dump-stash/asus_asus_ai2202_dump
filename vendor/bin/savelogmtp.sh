#!/vendor/bin/sh

# savelog
#echo $0 > /dev/kmsg

# check mount file
	umask 0;
	sync

# which folder sepolicy type is file_type
VENDOR_DATA_TMP=/logbuf
mkdir -p $VENDOR_DATA_TMP
chmod -R 777 $VENDOR_DATA_TMP

# copy vendor data file function
function move_vendor_logs(){
	chmod -R 777 $VENDOR_FOLDER
	echo "$0: type $1"
	cat $LOG_LIST | while read line; do
		mkdir -p $VENDOR_DATA_TMP/$1
		chmod -R 777 $VENDOR_DATA_TMP/$1
		echo "savelogmtp: move_vendor_logs: file $line" > /dev/kmsg
		cp $line $VENDOR_DATA_TMP/$1/
		start log_mover
		#check log_mover stopped
		while : ; do
			sleep 1
			if test -e "$VENDOR_DATA_TMP/ls_vendor_data_tmp.txt"; then
				echo "$0: log_mover is running..."
			else
				if test -d "$VENDOR_DATA_TMP/$1"; then
					echo "$0: log_mover is running.."
				else
					echo "$0: log_mover is stopped."
					break
				fi
			fi
		done
		echo "$0: -------"
	done
}
###########################################################################################
# WIFI/wlan_logs
VENDOR_FOLDER=/data/vendor/wifi/wlan_logs
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
find $VENDOR_FOLDER -type f > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
chmod -R 777 $VENDOR_FOLDER
# start log_mover
move_vendor_logs wlan_logs
echo "$0: cp -r /data/vendor/wifi/wlan_logs"

#WIFI/hostapd
VENDOR_FOLDER=/data/vendor/wifi/hostapd
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
find $VENDOR_FOLDER -type f -name "*.conf" > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
chmod -R 777 $VENDOR_FOLDER
# start log_mover
move_vendor_logs wifi_config
echo "$0: cp -r /data/vendor/wifi/hostapd"

#WIFI/wpa
VENDOR_FOLDER=/data/vendor/wifi/wpa
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
find $VENDOR_FOLDER -type f -name "*.conf" > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
chmod -R 777 $VENDOR_FOLDER
# start log_mover
move_vendor_logs wifi_config
echo "$0: cp -r /data/vendor/wifi/wpa"
###########################################################################################
# Bluetooth/ssrdump
VENDOR_FOLDER=/data/vendor/ssrdump
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
find $VENDOR_FOLDER -type f > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
chmod -R 777 $VENDOR_FOLDER
# start log_mover
move_vendor_logs btsnoop
rm -r /data/vendor/ssrdump/*.*
echo "$0: cp -r /data/vendor/ssrramdump"
###########################################################################################
#add to stop and then capture modem log problem
enableQXDM=`getprop persist.logd.qxdmlog.enable`
echo "$0: persist.logd.qxdmlog.enable=$enableQXDM"
if [ "${enableQXDM}" = "1" ]; then
    setprop vendor.logd.qxdmlog.enable 0
    echo "Turn off QXDM log for savelogmtp" > /dev/kmsg
    sleep 1
    sync
fi

# SSR ramdump
VENDOR_FOLDER=/data/vendor/ramdump/ssr_ramdump
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
chmod -R 777 $VENDOR_FOLDER
find $VENDOR_FOLDER -type f > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
# start log_mover
move_vendor_logs ssr_ramdump
rm -r /data/vendor/ramdump/ssr_ramdump/
echo "$0: cp -r /data/vendor/ramdump/ssr_ramdump"

# QXDM/diag_logs
VENDOR_FOLDER=/data/vendor/ramdump/diag_logs
echo "$0: ++++ VENDOR_FOLDER=$VENDOR_FOLDER ++++"
chmod -R 777 $VENDOR_FOLDER
find $VENDOR_FOLDER -type f > $VENDOR_FOLDER/filelist.txt
LOG_LIST=$VENDOR_FOLDER/filelist.txt
# start log_mover
move_vendor_logs diag_logs
rm -r /data/vendor/ramdump/diag_logs/*
echo "$0: cp -r /data/vendor/ramdump/diag_logs"
sync

#add to stop and then capture modem log problem
if [ "${enableQXDM}" = "1" ]; then
    setprop vendor.logd.qxdmlog.enable 1
    echo "Turn on QXDM log for savelogmtp" > /dev/kmsg
fi
setprop vendor.logd.qxdmlog.enable ""
QXDM_tag=`getprop vendor.logd.qxdmlog.enable`
echo "$0: vendor.logd.qxdmlog.enable=$QXDM_tag"
##############################################################################################
start savelogmtp_sys
echo "$0: DONE!!!"
exit
