ARG DEBIAN_VERSION=bookworm-slim
FROM debian:${DEBIAN_VERSION} AS downloader

ARG TERRAFORM_VERSION=latest
ARG TERRAGRUNT_VERSION=latest
ARG AWSCLI_VERSION=latest

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/dl
RUN mkdir -p /out/bin

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    V="${TERRAFORM_VERSION}"; \
    if [ "$V" = "latest" ]; then \
        V="$(curl -fsSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)"; \
    fi; \
    echo "Installing terraform ${V}"; \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${V}/terraform_${V}_linux_${ARCH}.zip"; \
    curl -fsSLO "https://releases.hashicorp.com/terraform/${V}/terraform_${V}_SHA256SUMS"; \
    grep "terraform_${V}_linux_${ARCH}.zip" "terraform_${V}_SHA256SUMS" | sha256sum -c -; \
    unzip -q "terraform_${V}_linux_${ARCH}.zip" terraform -d /out/bin; \
    rm -f ./*

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    if [ "${TERRAGRUNT_VERSION}" = "latest" ]; then \
        BASE="https://github.com/gruntwork-io/terragrunt/releases/latest/download"; \
    else \
        BASE="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}"; \
    fi; \
    curl -fsSLO "${BASE}/terragrunt_linux_${ARCH}"; \
    curl -fsSLO "${BASE}/SHA256SUMS"; \
    grep " terragrunt_linux_${ARCH}$" SHA256SUMS | sha256sum -c -; \
    install -m 0755 "terragrunt_linux_${ARCH}" /out/bin/terragrunt; \
    rm -f ./*

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    if [ "$ARCH" = "arm64" ]; then AWS_ARCH=aarch64; else AWS_ARCH=x86_64; fi; \
    if [ "${AWSCLI_VERSION}" = "latest" ]; then \
        ZIP="awscli-exe-linux-${AWS_ARCH}.zip"; \
    else \
        ZIP="awscli-exe-linux-${AWS_ARCH}-${AWSCLI_VERSION}.zip"; \
    fi; \
    curl -fsSL -o awscliv2.zip "https://awscli.amazonaws.com/${ZIP}"; \
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
