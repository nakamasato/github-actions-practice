FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ARG KUBECTL_VERSION=v1.22.0
ARG CALICOCTL_VERSION=v3.17.1
ARG YQ_VERSION=v4.6.2
ARG KUBESEAL_VERSION=v0.13.1
ARG AWSCLI_VERSION=2.2.40

# apt install
RUN apt update && apt install -y \
    curl \
    groff \
    jq \
    less \
    git \
    openssh-server \
    cron \
    sudo \
    supervisor \
    python3-distutils \
    gnupg \
    make \
    zsh \
    tmux \
    tree \
    netcat \
    dnsutils \
    unzip \
    mysql-client \
    postgresql-client \
    redis-server \
    stunnel \
    tig \
    vim \
    unzip \
    python3-boto3 \
    python3-pandas

# Install awscli https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Install aws-rotate-iam-keys https://github.com/rhyeal/aws-rotate-iam-keys#other-linux
RUN git clone https://github.com/rhyeal/aws-rotate-iam-keys.git && \
    sudo cp aws-rotate-iam-keys/src/bin/aws-rotate-iam-keys /usr/bin/ && \
    rm -rf aws-rotate-iam-keys

# Install pip
RUN curl "https://bootstrap.pypa.io/get-pip.py" | python3

# Install pip libraries
RUN pip install \
    PyMySQL==0.9.3 \
    pre-commit \
    cryptography \
    cassandra-driver==3.24 \
    cqlsh==6.0.0

RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install calicoctl
RUN curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/${CALICOCTL_VERSION}/calicoctl && \
    chmod +x calicoctl && \
    cp ./calicoctl /usr/bin/calicoctl

# Install kubeseal
RUN wget https://github.com/bitnami-labs/sealed-secrets/releases/download/${KUBESEAL_VERSION}/kubeseal-linux-amd64 -O kubeseal && \
    sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# Install google cloud sdk
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# Install yq
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq
