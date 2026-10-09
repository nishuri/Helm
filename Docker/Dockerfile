ARG DEBIAN_VERSION=trixie-slim
ARG TERRAFORM_VERSION=1.16.5
ARG TERRAGRUNT_VERSION=1.1.6
ARG AWSCLI_VERSION=2.37.3

FROM debian:${DEBIAN_VERSION} AS downloader

ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
ARG AWSCLI_VERSION

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/dl
RUN mkdir -p /out/bin

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip"; \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"; \
    grep "terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum -c -; \
    unzip -q "terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip" terraform -d /out/bin; \
    rm -f ./*

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    BASE="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}"; \
    curl -fsSLO "${BASE}/terragrunt_linux_${ARCH}"; \
    curl -fsSLO "${BASE}/SHA256SUMS"; \
    grep " terragrunt_linux_${ARCH}$" SHA256SUMS | sha256sum -c -; \
    install -m 0755 "terragrunt_linux_${ARCH}" /out/bin/terragrunt; \
    rm -f ./*

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    if [ "$ARCH" = "arm64" ]; then AWS_ARCH=aarch64; else AWS_ARCH=x86_64; fi; \
    curl -fsSL -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}-${AWSCLI_VERSION}.zip"; \
    unzip -q awscliv2.zip; \
    ./aws/install --install-dir /usr/local/aws-cli --bin-dir /out/bin; \
    rm -rf /usr/local/aws-cli/v2/current/dist/aws_completer \
           /usr/local/aws-cli/v2/current/dist/awscli/examples \
           awscliv2.zip aws

FROM debian:${DEBIAN_VERSION} AS final

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git jq \
    && rm -rf /var/lib/apt/lists/*

COPY --from=downloader /usr/local/aws-cli /usr/local/aws-cli
COPY --from=downloader /out/bin/ /usr/local/bin/

ENV AWS_PAGER="" \
    TF_IN_AUTOMATION=1 \
    TF_INPUT=0

WORKDIR /workspace
RUN terraform version && terragrunt --version && aws --version
