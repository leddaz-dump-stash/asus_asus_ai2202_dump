#!/vendor/bin/sh

BATTERY=`cat /sys/class/extcon-asus/battery/name`
setprop vendor.battery.version.driver "$BATTERY"
