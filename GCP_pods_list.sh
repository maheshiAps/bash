#!/bin/bash  
gcloud container clusters get-credentials <GCP-cluter-name> --region <region> --project <progect-name>
rm -rf servicesList
echo "No of NameServers : " 
read -a ns <<< "ns2-services ns3-services ns4-services ns5-services ns6-services"
echo ${#ns[@]}
for i in ${ns[@]}
do
   namespaces=($( kubectl get ns | egrep -i "$i" | awk '{print $1}'))
   kubectl config set-context --current --namespace="$namespaces" 
   kubectl get deployments -o wide -A | grep $namespaces | awk '{print $1,$2}' | sed -n '1!p' >> servicesList
   echo No of deploymnet in ${namespace} $(kubectl get deployments  | awk '{print $1}' | sed -n '1!p' | wc -l)
   kubectl get sts -o wide -A | grep  $namespaces | awk '{print $1,$2}' | sed -n '1!p' >> servicesList
   echo No of sts in ${namespace} $(kubectl get sts  | awk '{print $1}' | sed -n '1!p' | wc -l)
 
done
echo -e "All  services are listed in >> \033[0;32m servicesList \n"
