#!/bin/bash
base=/project/consultron/tools
DIR=/usr/bin
comm=Qmon
echo "Nodo|IP|Ping|Snmp" > $base/$1.txt

for i in `cat $base/Equipos.csv | sed 's/ * /_/g'`
do
        ip=`echo $i | cut -d ";" -f7`
        node=`echo $i | cut -d ";" -f4`
		if [ `ping $ip -c 2 -W 1 | grep -c  "time="` -gt 0 ]
		then
		sleep 1
		$DIR/snmpget -v 2c -c $comm $ip 1.3.6.1.2.1.1.5.0
		if [ "$?" -eq "1" ]
                then
				echo "$node|$ip|pOK|sNOK" >> $base/$1.txt
				else
				echo "$node|$ip|pOK|sOK" >> $base/$1.txt
				fi
		else
		echo "$node|$ip|Error" >> $base/$1.txt
		sleep 1
		fi
done

