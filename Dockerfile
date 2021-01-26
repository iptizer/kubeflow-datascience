FROM jupyter/datascience-notebook:latest 

RUN pip3 install jupyterlab jupyterlab-git kfp kfp-server-api kubernetes kubeflow-kale kfserving \
    kubeflow-fairing && \
    conda install -y -c conda-forge nodejs jupyter-lsp-python jupyterlab-git && \
    jupyter labextension install kubeflow-kale-labextension && \
    jupyter labextension install '@jupyter-widgets/jupyterlab-manager' && \
    jupyter labextension install '@krassowski/jupyterlab-lsp'

CMD ["sh", "-c", \
     "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
      --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
      --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]