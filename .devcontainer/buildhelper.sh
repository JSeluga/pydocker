#/bin/bash

echo "The script you are running has basename $( basename -- "$0"; ), dirname $( dirname -- "$0"; )";
echo "The present working directory is $( pwd; )";

#docker build --no-cache --progress=plain --secret id=mysecret,src=mysecret.txt --secret id=azdevopstoken,src=azuredevopspat .
docker build --progress=plain --secret id=azdevopstoken,src=.devcontainer/azuredevopspat .devcontainer/