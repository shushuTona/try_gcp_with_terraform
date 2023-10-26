FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
                                                                wget \
                                                                sudo \
                                                                gnupg \
                                                                apt-transport-https \
                                                                ca-certificates \
                                                                software-properties-common \
                                                                curl

# install terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
        sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN sudo apt update && sudo apt install -y terraform

# install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
        tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
        apt-get update -y && apt-get install google-cloud-cli -y

RUN mkdir try_gcp_with_terraform

WORKDIR /try_gcp_with_terraform
