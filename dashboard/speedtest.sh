#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Speedtest
# @raycast.mode inline
# @raycast.author Caleb Stauffer
# @raycast.authorURL https://github.com/crstauf
# @raycast.description Test download and upload connection speed
# @raycast.packageName Internet
# @raycast.icon images/speedtest-logo.png
# @raycast.refreshTime 20m

if ! command -v speedtest &> /dev/null; then
	echo "speedtest command is required (https://www.speedtest.net/apps/cli).";
	exit 1;
fi

if ! command -v jq &> /dev/null; then
	echo "jq is required (https://stedolan.github.io/jq/).";
	exit 1;
fi

json=$(speedtest -f json-pretty)

    ping=$(echo "$json" | jq -r '.ping.latency')
bps_down=$(echo "$json" | jq -r '.download.bandwidth')
  bps_up=$(echo "$json" | jq -r '.upload.bandwidth')

divide_to_mbps=125000
mbps_down=$(echo "scale=2; $bps_down / $divide_to_mbps" | bc)
  mbps_up=$(echo "scale=2;   $bps_up / $divide_to_mbps" | bc)

echo "↑ ${mbps_down}mbps  ↓ ${mbps_up}mbps  ↔ ${ping}ms"