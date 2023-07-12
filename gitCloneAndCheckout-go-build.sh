#!/bin/bash

IFS=" "

read -p "Enter gitcloneURL and the tagVersion(git@<host>:devops/<repo path>.git <tag/version>):" input1 input2 
go version 
go env  
git clone "$input1"
ll
read -p "Repository Name(Cloning into name):" input3
cd "$input3"
git branch
git checkout tags/"$input2" -b "$input2"
git branch
go clean -modcache
go mod tidy
go build
