FROM jupyter/datascience-notebook:latest 

RUN conda install jupyterlab jupyterlab-git kfp kfp-server-api kfserving kubernetes kubeflow-kale && \
    jupyter labextension install kubeflow-kale-labextension

CMD ["sh", "-c", \
     "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
      --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
      --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]