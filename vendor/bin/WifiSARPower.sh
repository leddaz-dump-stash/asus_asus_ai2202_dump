ReceiverOn=`getprop log.asus.sar.audio`
Wifion=`getprop wlan.driver.status`
Country=`getprop vendor.asus.operator.iso-country`
Camera=`getprop vendor.asus.tel.antenna`
#SKU=`getprop ro.boot.id.prj`
#CustomerID=`getprop ro.config.CID`
WWANon=`getprop vendor.ril.tel.mobiledata`
Softapon=`getprop vendor.wlan.softap.driver.status`
#WlanDbs=`getprop vendor.wlan.dbs`
Slm=`getprop vendor.sla.enabled`

log -t WifiSARPower enter Wifion=$Wifion Country=$Country ReceiverOn=$ReceiverOn Softapon=$Softapon Slm=$Slm WWANon=$WWANon

if [ "$Country" == "US" ]; then
    if [ "$ReceiverOn" == "1" ]; then
        if [ "$WWANon" == "1" ]; then
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 2 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 2 --END_ATTR --END_ATTR --END_CMD
            log -t WifiSARPower US/recevier on and WWAN on
        else
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD
            log -t WifiSARPower US/recevier on and WWAN off
        fi
    elif [ "$WWANon" == "1" ]; then
        if [ "$Softapon" == "ok" ] || [ "$Slm" == "1" ]; then
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 3 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 3 --END_ATTR --END_ATTR --END_CMD
            log -t WifiSARPower US/WWAN on and softap/slm on
        else
            vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD
            log -t WifiSARPower US/WWAN on only, reset to default
        fi
    else
        vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

        log -t WifiSARPower US reset to default
    fi
else
    log -t WifiSARPower Not tirgger
fi

