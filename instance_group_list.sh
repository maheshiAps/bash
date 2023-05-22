#!/bin/bash

rm -rf vmgrouplist vmname singleInstanceGroup.csv
#gcloud auth activate-service-account --key-file=${SERVICE_ACCOUNT}
gcloud container clusters get-credentials <gcp-cluster> --region <region> --project <project>

gcloud compute instance-groups list >> vmgrouplist

awk '{ print $1,$6 }' vmgrouplist > vmname

awk '{ if($2 == "1") print $1;}' vmname > singleInstanceGroup.csv

echo -e "KIndly check the singleInstanceGroup.csv file as the output"
