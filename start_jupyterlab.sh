#!/bin/bash

NB_HOME="/home/jovyan"

# create kfp config
if [[ -f /run/secrets/kubernetes.io/serviceaccount/namespace ]]; then
    mkdir -p ${NB_HOME}/.config/kfp/
    echo "{\"namespace\": \"$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)\"}" >${NB_HOME}/.config/kfp/context.json
fi

jupyter lab --notebook-dir=/home/${NB_HOME} --ip=0.0.0.0 --no-browser \
    --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
    --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}
