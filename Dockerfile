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

COPY ./start_jupyterlab.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/start_jupyterlab.sh && \
    echo "jovyan ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan

USER jovyan

WORKDIR /tmp/

COPY ./pipenv /tmp/
RUN pip install --upgrade pip && \
    conda install -y -c conda-forge 'jupyterlab>=2.2,<3.0.0a0' 'nodejs>=10.12,<15' \
    'jupyter-lsp-python=0.9.3' jupyterlab-git ipympl && \
    pip install pipenv && pipenv install && \
    jupyter labextension install kubeflow-kale-labextension && \
    jupyter labextension install '@jupyter-widgets/jupyterlab-manager' && \
    jupyter labextension install '@krassowski/jupyterlab-lsp@2.1.2' && \
    rm -rf /tmp/*

WORKDIR /home/jovyan

CMD ["/usr/local/bin/start_jupyterlab.sh"]