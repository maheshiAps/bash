#!/bin/bash
GL_DOMAIN="https://git.<domian>.lk" //"https://git.test.lk"
GL_TOKEN="<gitToken>"
echo "" > gitlab_projects_urls.txt
for ((i=1; ; i+=1)); do
    contents=$(curl "$GL_DOMAIN/api/v4/groups/<projectID>/projects?private_token=$GL_TOKEN&include_subgroups=true&all_available=true&per_page=100&page=$i")
    if jq -e '. | length == 0' >/dev/null; then 
       break
    fi <<< "$contents"
    echo "$contents" | jq -r '.[].ssh_url_to_repo' >> gitssh.txt
done
