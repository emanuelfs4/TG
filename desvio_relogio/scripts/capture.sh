#!/bin/bash

# Enable monitor mode before capturing

router="manel"

mkdir data_$router

mac="4C:17:EB:D8:B4:29"

sudo tshark -f "wlan[0] == 0x80 && (wlan src $mac)" -i wlan2mon -V -c 1000 | tee "data_$router/capture.txt"  

#Extracting data from the captured beacons
#AP beacon timestamps:
awk '/Timestamp/ { print $2 }' "data_$router/capture.txt" > "data_$router/beacon_timestamps.txt"
#Station radiotap timestamps:
awk '/MAC timestamp/ { print $3 }' "data_$router/capture.txt" > "data_$router/station_timestamps.txt"
