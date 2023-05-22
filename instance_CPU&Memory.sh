#!/bin/bash

rm -rf vm vmm vmmm vm-out
gcloud container clusters get-credentials <cluster-name> --region <region> --project <project-name>
gcloud compute instances list --project <project-name> > vm
 
echo "$(tail -n +2 vm)" > vmm
echo "$(cat vm | egrep -i 'sn-|lum-|portal|capp')" > vmm
echo "$(cat vmm | awk '{print $1, $2, $3}')" > vmmm

IFS=$'\n'
FILE="vmmm"
echo `cat vmm | wc -l`

for LL in `cat $FILE`
do
	echo $LL
	echo "$LL"| awk '{print $1}' >> vm-out 
	#KEY=`echo "$LL"|grep -o '^[^ ]*'`
	k1=`echo "$LL"| awk '{print $2}'`
	echo "$k1"
	#KEY1=`echo "$LL"|sed "s^$KEY ^^"`
	k2=`echo "$LL"| awk '{print $3}'`
	echo "$k2"
	gcloud compute machine-types describe "$k2" --zone="$k1" --project <project-name> | egrep -i 'description|memoryMb'>> vm-out

done
