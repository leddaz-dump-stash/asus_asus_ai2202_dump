wifi_mac=`sed -n '1 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf0MacAddress=/ }
setprop ro.vendor.wifimac $wifi_mac
wifi_mac=`sed -n '2 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf1MacAddress=/ }
setprop ro.vendor.wifimac_2 $wifi_mac

#wigig_mac=`cat /vendor/factory/wigig_mac.bin`
#setprop ro.wigigmac $wigig_mac

setprop vendor.wifi.version.driver WLAN.HSP.2.0-01579.7-QCAHSPSWPL_V1_V2_SILICONZ-1.498569.2.503417.4
#setprop wigig.version.driver 5.3.0.72
#setprop wigig.dock.version.driver v0.0.0.10

# BT
setprop vendor.bt.version.driver BTFW.HSP.2.1.0-00386-PATCHZ-1
setprop ro.vendor.btmac `btnvtool -x 2>&1`
