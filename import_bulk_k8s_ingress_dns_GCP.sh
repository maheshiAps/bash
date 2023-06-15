#!/bin/bash
gcloud container clusters get-credentials <clustername> --region <region> --project <projectID>
read -a ns <<< "namespace1 namespace2 namespace3 namespace1"

for i in ${ns[@]}
do

	kubectl describe ingress k8s-"$i"-ingress -n "$i" | grep .ridefastnow.com | sed '1d' | sed 's/ //g' >> dns-list
	ip=$(kubectl describe ingress k8s-"$i"-ingress -n "$i" | grep -i address |awk {'print $2'})


done

input="dns-list"

while read -r line
do

  echo "$line. 300 IN A $ip" >> zone-file

done < "$input"

gcloud dns record-sets import -z=<zonename> \
   --zone-file-format zone-file
