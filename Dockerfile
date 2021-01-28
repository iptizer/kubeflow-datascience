FROM jupyter/datascience-notebook:latest 

USER root

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

USER jovyan

WORKDIR /tmp/

COPY ./Pipfile /tmp/
RUN pip install --upgrade pip && \
    conda install -y -c conda-forge 'jupyterlab>=2.2,<3.0.0a0' 'nodejs>=10.12,<15' \
    'jupyter-lsp-python=0.9.3' jupyterlab-git ipympl && \
    pip install pipenv && pipenv install && \
    jupyter labextension install kubeflow-kale-labextension && \
    jupyter labextension install '@jupyter-widgets/jupyterlab-manager' && \
    jupyter labextension install '@krassowski/jupyterlab-lsp@2.1.2' && \
    rm -rf /tmp/*


WORKDIR /home/jovyan

CMD ["sh", "-c", \
    "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
    --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
    --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]