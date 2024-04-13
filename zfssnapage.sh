#!/bin/bash
# 20240103
# check age of newest snapshot
# output for checkmk
warnmaxage=7200
critmaxage=86400
now=$(/usr/bin/date '+%s')
for i in $(zfs list -H -o name); do
  line=$(zfs list -p -H -r -d 1 -t snap -o name,creation -S creation "${i}" | head -n1)
  #echo $line
  snaptime=$(echo $line | tr " " "\t" | cut -f2)
  snapshot=$i

  if [[ -z "$snaptime" ]]; then
    snaptime="-"
    snapage="-"
  else
    snapage=$(expr $now - $snaptime)
  fi

#  if (( maxage > snapage )); then
#    snapstate="0"
#  else
#    snapstate="1"
#  fi
#  echo $snapstate $snapshot age=$snapage
  echo P \"Snapshot age $snapshot\" age=$snapage\;$warnmaxage\;$critmaxage age in seconds of the newest snapshot
done