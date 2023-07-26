#!/bin/bash
#read -a ns <<< "pas-ser dr-ser fin-ser  co-ser common protected" tree structure directories or path
read -a ns <<< "pas-services"



echo ${#ns[@]}
for i in ${ns[@]}
do
        etcdctl --endpoints <etcd ip>:2379 --user <username/root> --password <password> get /system/"$i" --prefix > etcd-value-"$i"
        cat etcd-value-"$i" | awk '{print $1}' | grep ^/system > etcd-path-"$i"
        input="etcd-path-$i"

        >valueonly  #truncate files
        >singlevalue-"$i"
        >nonsinglevalue-"$i"
	      >zerovalue-"$i"


        while IFS= read -r line
        do
        echo "line- $line"

        echo "`etcdctl --endpoints <etcd ip>:2379 --user <username/root> --password <password> get "$line" --print-value-only`" > valueonly
        if [ "`cat valueonly |wc -l`" == 0 ]
        then
           echo "$line `etcdctl --endpoints <etcd ip>:2379 --user <username/root> --password <password> get "$line" --print-value-only`" >> zerovalue-"$i"
	      elif [ "`cat valueonly |wc -l`" == 1 ]
	      then
	      echo "$line `etcdctl --endpoints <etcd ip>:2379 --user <username/root> --password <password> get "$line" --print-value-only`" >> singlevalue-"$i"
        else
           echo "$line `etcdctl --endpoints <etcd ip>:2379 --user <username/root> --password <password> get "$line" --print-value-only`" >> nonsinglevalue-"$i"
        fi

        done < $input
done
