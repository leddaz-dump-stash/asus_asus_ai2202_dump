#!/vendor/bin/sh
#country.sh

## Use COUNTRY to set default_network
LOG_TAG="COUNTRY"

if test -f /vendor/factory/COUNTRY; then
   COUNTRYCODE=`cat /vendor/factory/COUNTRY | tr '[a-z]' '[A-Z]'`
   ##COUNTRYCODE=`getprop ro.vendor.config.versatility`
fi

case "$COUNTRYCODE" in
#CN/TW/EU/FR/HK/JP/ID enable 5G, 5G default on (2G/3G/4G/5G)
    "CN" | "TW" | "EU" | "FR" | "HK" | "JP" | "ID")
        setprop vendor.telephony.default_network 26,26
        setprop ro.vendor.asus.network.types 21
        ;;
#Others enable 5G, 5G default off (2G/3G/4G)
    *)
        setprop vendor.telephony.default_network 9,9
        setprop ro.vendor.asus.network.types 21
        ;;
esac

