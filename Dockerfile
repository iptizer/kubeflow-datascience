FROM jupyter/datascience-notebook:lab-2.2.9

USER root

WORKDIR /tmp/

COPY ./Pipfile /tmp/

# see docs here https://jupyterlab-lsp.readthedocs.io/en/2.x/Installation.html
# consult 3.x docs when kale is readyfor jupyterlab 3
RUN conda install --quiet --yes --freeze-installed -c conda-forge \
    'python-language-server' \
    'jupyterlab>=2.2.0,<3.0.0a0' \
    'r-languageserver' \
    'texlab' \
    'chktex' \
    'nodejs' \
    'jupyter-lsp=0.9.3' \
  && pip install --upgrade pip \
  && pip install pipenv && pipenv lock && PIP_IGNORE_INSTALLED=1 pipenv install --system --deploy \
  && rm -rf /tmp/* \
  && jupyter labextension install --no-build '@jupyter-widgets/jupyterlab-manager' \
  && jupyter labextension install --no-build kubeflow-kale-labextension \
  && jupyter labextension install --no-build '@krassowski/jupyterlab-lsp@2.1.2' \
  && jupyter lab build --dev-build=False --minimize=True \
  && conda clean --all -f -y

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

USER jovyan
WORKDIR /home/jovyan

CMD ["sh", "-c", \
    "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser \
    --allow-root --port=8888 --LabApp.token='' --LabApp.password='' \
    --LabApp.allow_origin='*' --LabApp.base_url=${NB_PREFIX}"]