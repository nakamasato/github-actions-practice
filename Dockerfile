FROM ubuntu:21.10

COPY aws-ec2-ssh /aws-ec2-ssh

# Install dependent packages
RUN apt update && apt install -y \
    curl \
    unzip
# bash python curl groff jq less git openssh-server cron sudo supervisor python3-distutils gnupg make zsh tmux tree netcat dnsutils && \
# curl ${pip_installer} | python3 && \
# bash -c 'echo complete -C '/usr/bin/aws_completer' aws  >> $HOME/.bashrc' &&\
# echo 'export PATH=$PATH:/opt/cassandra/bin' >> /etc/profile

# install awscli latest version
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# RUN cd /aws-ec2-ssh && ./install.sh; exit 0 && cron
# COPY aws-ec2-ssh.conf /etc/aws-ec2-ssh.conf
# RUN mkdir -p /run/sshd
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# ENV PS1="\[\033[1;32m\][\t][\u@\h \W]\$\[\033[0m\]"
# COPY startup.sh /startup.sh
# RUN chmod 744 /startup.sh

# # Install new libraries
# ARG PyMySQL_version="0.9.3"
# RUN apt install -y \
#     mysql-client postgresql-client redis-server stunnel tig \
#     vim emacs unzip \
#     python3-boto3 python3-pandas && \
#     pip install PyMySQL==${PyMySQL_version} pre-commit cryptography

# # Install kubectl
# RUN curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.11/2020-09-18/bin/linux/amd64/kubectl && \
#     chmod +x ./kubectl && \
#     cp ./kubectl /usr/bin/kubectl

# # Install calicoctl
# RUN curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.17.1/calicoctl && \
#     chmod +x calicoctl && \
#     cp ./calicoctl /usr/bin/calicoctl

# # Install kubeseal
# RUN wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.13.1/kubeseal-linux-amd64 -O kubeseal && \
#     sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# # Install aws-iam-authenticator
# RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.8/2020-09-18/bin/linux/amd64/aws-iam-authenticator && \
#     chmod +x ./aws-iam-authenticator && \
#     cp ./aws-iam-authenticator /usr/bin/aws-iam-authenticator

# # Install google cloud sdk
# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
#     tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
#     apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
#     apt-get update -y && apt-get install google-cloud-sdk -y

# # Install yq
# RUN wget https://github.com/mikefarah/yq/releases/download/v4.6.2/yq_linux_amd64 -O /usr/bin/yq && \
#     chmod +x /usr/bin/yq

# CMD ["/startup.sh"]
