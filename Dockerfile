# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.0/containers/ubuntu/.devcontainer/base.Dockerfile

ARG VARIANT="ubuntu-22.04"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# https://bobcares.com/blog/debian_frontendnoninteractive-docker/
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  bash-completion \
                        pip \
                        python-is-python3

# https://docs.docker.com/engine/install/ubuntu/
RUN apt-get install -y  ca-certificates \
                        curl \
                        gnupg \
                        lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y  docker-ce \
                        docker-ce-cli \
                        containerd.io \
                        docker-compose-plugin

RUN usermod -a -G docker vscode

# -- Python 3.12
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y python3.11

# -- Poetry
RUN export POETRY_HOME=/opt/poetry && \
    export POETRY_VERSION=1.3.0 && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    install -o root -g root -m 555 /opt/poetry/bin/poetry /usr/local/bin/poetry

USER vscode

RUN pip install --no-warn-script-location  \
                commitizen
