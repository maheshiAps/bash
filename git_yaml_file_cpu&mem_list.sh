#!/bin/bash

file="gitssh.txt"
result_file="output.csv"

header="repo_url,service_name,cpu,memory"
echo $header>$result_file

for LL in `cat $file`
 do
 echo "processing repo :".$LL
 git clone $LL
 service=`echo "$LL" |  tail -1 |cut -f4 -d"/" | sed 's/.git/ /g'`
 cd $service
 if cd prod/k8s/
 then
  git branch
  #cd prod/k8s/
  pwd
  cpu=`cat *.yaml | grep cpu: | head -1 | xargs | cut -d ' ' -f2`
  mem=`cat *.yaml | grep memory: | head -1 | xargs | cut -d ' ' -f2`
  cd ../../..
  echo  "$LL $service $cpu $mem" >>$result_file
  pwd
  rm -rf $service
 
else
 cd /home/maheshi
 rm -rf $service
fi 
done
