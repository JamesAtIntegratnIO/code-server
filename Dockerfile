FROM codercom/code-server:latest as base

RUN sudo apt update && sudo apt install --no-install-recommends -y \
    jq \
    xz-utils \
    unzip \
    && sudo rm -rf /var/lib/apt/lists/*

FROM base as nix
# install nix
WORKDIR /home/coder
USER coder
RUN curl -L https://nixos.org/nix/install | sh


FROM nix as extensions

ENV VSCODE_USER /home/coder/.local/share/code-server/User
ENV VSCODE_EXTENSIONS /home/coder/.local/share/code-server/extensions
# ENV SERVICE_URL https://open-vsx.org/vscode/gallery
# ENV ITEM_URL https://open-vsx.org/vscode/item

RUN code-server --install-extension golang.go \
    code-server --install-extension mhutchie.git-graph \
    code-server --install-extension eamodio.gitlens \
    code-server --install-extension ms-python.python \
    code-server --install-extension rust-lang/rust-analyzer \
    code-server --install-extension bbenoist.nix \
    code-server --install-extension arrterian.nix-env-selector \
    code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
    code-server --install-extension ms-azuretools.vscode-docker \
    code-server --install-extension timonwong.shellcheck \
    code-server --install-extension tamasfe.even-better-toml \
    code-server --install-extension redhat.vscode-yaml \
    code-server --install-extension hashicorp.terraform \

# Extensions for my KB \
    code-server --install-extension foam.foam-vscode \
    code-server --install-extension yzhang.markdown-all-in-one \
    code-server --install-extension bierner.emojisense \
    code-server --install-extension bierner.markdown-mermaid \
    code-server --install-extension tomoki1207.pdf \
    code-server --install-extension gruntfuggly.todo-tree \
    code-server --install-extension esbenp.prettier-vscode \

FROM extensions as packages

# Install packages
ENV KUBECTL_VERSION 1.27.4
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && sudo install kubectl /usr/local/bin \
    && kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl \
    && rm kubectl

ENV HELM_VERSION 3.13.3
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
    && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && sudo install linux-amd64/helm /usr/local/bin \
    && helm completion bash | sudo tee /etc/bash_completion.d/helm \
    && rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

ENV TERRAFORM_VERSION 1.6.6
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && sudo install terraform /usr/local/bin \
    && terraform -install-autocomplete \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform

