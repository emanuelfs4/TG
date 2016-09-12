#!/bin/bash

#### IMPORTANT!!! ####
# Enable monitor mode before capturing
######################

#Interface in monitor mode (mon0, wlan0mon...)

$interface="INTERFACE_IN_MONITOR_MODE"

router="ROUTER_NAME"

#Create directory of each router
mkdir data_$router

#Capture packets from router with the following MAC Address.
mac="ROUTER_MAC_ADDRESS"

#Command to filter only beacon frames of specific MAC Address and write the dada to the capture.txt file.
sudo tshark -f "wlan[0] == 0x80 && (wlan src $mac)" -i $interface -V -c 1000 | tee "data_$router/capture.txt"  


#Extracting data from the captured beacons

#AP beacon timestamps:
awk '/Timestamp/ { print $2 }' "data_$router/capture.txt" > "data_$router/beacon_timestamps.txt"

#Station radiotap timestamps:
awk '/MAC timestamp/ { print $3 }' "data_$router/capture.txt" > "data_$router/station_timestamps.txt"
