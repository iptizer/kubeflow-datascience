FROM jupyter/datascience-notebook

COPY requirements.txt /home/jovyan/
RUN pip install --upgrade pip \
    && pip uninstall -y distributed \
    && pip install -r requirements.txt \
    && rm /home/jovyan/requirements.txt

# see docs here https://jupyterlab-lsp.readthedocs.io/en/2.x/Installation.html
# consult 3.x docs when kale is readyfor jupyterlab 3
RUN conda install --quiet --yes --freeze-installed -c conda-forge \
    'python-language-server' \
    'jupyterlab>=3.0.0,<4.0.0a0' \
    'r-languageserver' \
    'texlab' \
    'chktex' \
    'nodejs' \
    'jupyterlab-lsp' \
    && jupyter labextension install --no-build '@jupyter-widgets/jupyterlab-manager' \
    #&& jupyter labextension install --no-build kubeflow-kale-labextension \
    #&& jupyter labextension disable kubeflow-kale-labextension \
    && jupyter labextension install --no-build '@krassowski/jupyterlab-lsp' \
    && jupyter labextension install --no-build 'jupyterlab-plotly-extension' \
    #&& jupyter labextension disable \
    #"@elyra/code-snippet-extension,@elyra/metadata-extension,@elyra/pipeline-editor-extension,@elyra/python-editor-extension,@elyra/r-editor-extension,@elyra/theme-extension" \
    && jupyter lab build --dev-build=False --minimize=True \
    && conda clean --all -f -y

USER root
WORKDIR /root/

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

COPY ./start_jupyterlab.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/start_jupyterlab.sh && \
    echo "jovyan ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/jovyan

USER jovyan
WORKDIR /home/jovyan

CMD ["/usr/local/bin/start_jupyterlab.sh"]
