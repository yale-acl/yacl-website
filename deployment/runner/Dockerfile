FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNNER_VERSION=2.325.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    libicu74 \
    rsync \
    ruby \
    ruby-bundler \
    ruby-dev \
    build-essential \
    libffi-dev \
    libyaml-dev \
    openssh-client \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash runner
WORKDIR /home/runner

RUN curl -fsSL -o actions-runner.tar.gz \
    "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    && tar -xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz \
    && chown -R runner:runner /home/runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner
ENTRYPOINT ["/entrypoint.sh"]
