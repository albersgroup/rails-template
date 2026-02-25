ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    bash-completion \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js
ARG NODE_VERSION=20
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Enable corepack for Yarn (skip download prompt)
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable && corepack prepare yarn@4.6.0 --activate

# Set working directory
# IMPORTANT: Change APP_NAME to match your repository name.
# Must match workspaceFolder in devcontainer.json and the volume in docker-compose.yml.
WORKDIR /workspaces/APP_NAME

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
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives \
    && chown -R $USERNAME:$USERNAME /workspaces/APP_NAME \
    && mkdir -p /home/$USERNAME/.bundle /workspaces/APP_NAME/node_modules \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.bundle /workspaces/APP_NAME/node_modules

USER $USERNAME

# Configure bash completion for git and other tools
RUN echo '# Enable bash completion' >> /home/$USERNAME/.bashrc \
    && echo 'if [ -f /usr/share/bash-completion/bash_completion ]; then' >> /home/$USERNAME/.bashrc \
    && echo '  . /usr/share/bash-completion/bash_completion' >> /home/$USERNAME/.bashrc \
    && echo 'fi' >> /home/$USERNAME/.bashrc

# Configure bundler to install gems in the user's home directory
ENV BUNDLE_PATH=/home/$USERNAME/.bundle \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0
