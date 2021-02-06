# kubeflow-datascience

<img alt="Docker Cloud Build Status" src="https://img.shields.io/docker/cloud/build/iptizer/kubeflow-datascience"> <img alt="Docker Cloud Automated build" src="https://img.shields.io/docker/cloud/automated/iptizer/kubeflow-datascience">

This notebook is built on the `jupyter/datascience-notebook` and adds:

* boto3 - Access AWS through Python
* jupyterlab extensions
  * Language server

TODO (not implemented):
  * Kale - JupyterLab extension that simplifies deploying Kubeflow pipelines.

## Add to Kubeflow

Use the following command to edit the configmap:

```sh
NAMESPACE=kubeflow
CONFIGMAP=$( kubectl get cm -n $NAMESPACE -l app=jupyter-web-app -o jsonpath="{$.items[0].metadata.name}")
kubectl edit cm -n $NAMESPACE $CONFIGMAP
```

In `data.spawner_ui_config.yaml`edit the list `spawnerFormDefaults.image.value` set the default image.

In `data.spawner_ui_config.yaml`edit the list `spawnerFormDefaults.image.options`. Add/ replace the following as a list item.

```yml
docker.io/iptizer/kubeflow-datascience:latest
```

## Image

This image is available on [https://hub.docker.com/repository/docker/iptizer/kubeflow-datascience](https://hub.docker.com/repository/docker/iptizer/kubeflow-datascience) or may be pulled with the following command:

```sh
docker pull docker.io/library/iptizer/kubeflow-datascience
```

Or build it locally:

```sh
docker login docker.io && \
docker build . -t iptizer/kubeflow-datascience:latest && \
docker push docker.io/iptizer/kubeflow-datascience:latest
```
