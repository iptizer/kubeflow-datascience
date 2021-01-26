# kubeflow-datascience

This notebook is built on the `jupyter/datasciene-notebook` and adds:

* Kale - JupyterLab extension that simplifies deploying Kubeflow pipelines.
* Few other nice-to-have JupyterLab extensions.

## Add to Kubeflow

Use the following command to edit the configmap:

```sh
NAMESPACE=kubeflow
CONFIGMAP=$( kubectl get cm -n $NAMESPACE -l app=jupyter-web-app -o jsonpath="{$.items[0].metadata.name}")
kubectl edit cm -n $NAMESPACE $CONFIGMAP
```

In `data.spawner_ui_config.yaml`edit the list `spawnerFormDefaults.image.options`. Add/ replace the following:

```yml
- docker.io/iptizer/kubeflow-datascience:latest
```

## Image

This image is available on [https://hub.docker.com/repository/docker/iptizer/kubeflow-datascience](https://hub.docker.com/repository/docker/iptizer/kubeflow-datascience) or may be pulled with the following command:

```sh
docker pull docker.io/library/iptizer/kubeflow-datascience
```

Or build it locally:

```sh
docker build . -t iptizer/kubeflow-datascience:latest
docker push iptizer/kubeflow-datascience:latest
```