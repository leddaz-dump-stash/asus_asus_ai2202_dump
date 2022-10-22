#!/vendor/bin/sh
TP_PATH=/sys/devices/platform/soc/990000.i2c/i2c-0/0-0038
#echo 1 > $TP_PATH/fts_hw_reset
#sleep 1.5
TP_VER_PACK=`cat $TP_PATH/fts_fw_version`

setprop vendor.touch.version.driver "$((16#$TP_VER_PACK))"

