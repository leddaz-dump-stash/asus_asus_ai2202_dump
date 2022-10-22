a=`cat /proc/cmdline`
test="androidboot.ddr.manufacturer_id="
pos=`awk -v a="$a" -v b="$test" 'BEGIN{print index(a,b)}'`
pos=`expr $pos - 1`
len=`echo ${#test}`
len=`expr $len + 2`
#echo $pos
#echo $len
#echo $a

target=${a:$pos:$len}
#echo $target

id=`echo $target|cut -d "=" -f 2`
#echo id=$id


if [ "$id" == "1" ]; then
	vid="SAMSUNG"
elif [ "$id" == "6" ]; then
	vid="HYNIX"
elif [ "$id" == "FF" ]; then
	vid="MICRON"
else
	vid="unknown_vendor"
fi

type="DDR5"


echo vid=$vid type=$type


sizeK=`cat /proc/meminfo  |grep -i MemTotal |awk '{print $2}'`
sizeM=`expr $sizeK / 1024`
sizeG=`expr $sizeM / 1024`
echo $sizeK KB
echo $sizeM MB
echo $sizeG GB
unit=GB

#setprop asus.ddr_info "$vid $type $sizeG$unit"
setprop vendor.asus.ddr_info "$vid"

setprop ro.vendor.atd.memvendor "$fake_id"
setprop ro.vendor.atd.platform "Qualcomm Snapdragon 8+ Gen 1 SM8475, Qcta-core CPUs, x 3.2GHz with 5G"

