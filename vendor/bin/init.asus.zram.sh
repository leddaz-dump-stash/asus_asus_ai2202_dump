#/system/bin/sh

disksize=`getprop persist.vendor.zram.disksize`
zram_enable=`getprop persist.vendor.zram.enable`

MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}
let RamSizeGB="( $MemTotal / 1048576 ) + 1"

if test "$disksize" = ""; then
	if [ $RamSizeGB -le 6 ]; then
		disksize="3072M"
	else
		disksize="4096M"
	fi
fi
if test "$zram_enable" = "1"; then
	swapoff /dev/block/zram0 2>/dev/kmsg
	echo 1 > sys/block/zram0/reset 2>/dev/kmsg
	sleep 1
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo $disksize > /sys/block/zram0/disksize 2>/dev/kmsg
	mkswap /dev/block/zram0 2>/dev/kmsg
	swapon /dev/block/zram0 -p 32758 2>/dev/kmsg
fi
if test "$zram_enable" = "0"; then
	swapoff /dev/block/zram0 2>/dev/kmsg
fi
if test "$zram_enable" = ""; then
	swapoff /dev/block/zram0 2>/dev/kmsg
	echo 1 > sys/block/zram0/reset 2>/dev/kmsg
	sleep 1
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo $disksize > /sys/block/zram0/disksize 2>/dev/kmsg
	mkswap /dev/block/zram0 2>/dev/kmsg
	swapon /dev/block/zram0 -p 32758 2>/dev/kmsg
fi

setprop vendor.asus.zram_setting 1
