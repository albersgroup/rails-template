ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Enable corepack for Yarn
RUN corepack enable && corepack prepare yarn@4.6.0 --activate

# Set working directory
WORKDIR /workspace

# Install bundler
RUN gem install bundler

# Create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

USER $USERNAME
