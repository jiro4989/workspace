ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION} as base

ARG WORKUSER
ARG LOCAL_UID
ARG LOCAL_GID
ARG PASSWORD
ARG EMAIL

ENV DEBIAN_FRONTEND=noninteractive
ENV SHFMT_VERSION=3.0.1
ENV DIRENV_VERSION=2.21.3
ENV RELMA_VERSION=1.7.5
ENV NODE_VERSION=18.x
ENV LAZYGIT_VERSION=0.34
ENV LANG="ja_JP.UTF-8"
ENV LANGUAGE="ja_JP:ja"
ENV LC_ALL="ja_JP.UTF-8"
ENV TZ="JST-9"
# tmux経由で256色描画できるようにする
ENV TERM="xterm-256color"

RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    ca-certificates \
    ctop \
    curl \
    docker.io \
    fish \
    git \
    htop \
    language-pack-ja \
    shellcheck \
    software-properties-common \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    \
 && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
 && apt-get install -y nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin
RUN wget -q "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" \
 && install -m 0755 nvim.appimage nvim \
 && wget -q "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" \
 && install -m 0755 shfmt_v${SHFMT_VERSION}_linux_amd64 shfmt \
 && wget -q "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64" \
 && install -m 0755 direnv.linux-amd64 direnv

WORKDIR /tmp

# relma
RUN wget -q https://github.com/jiro4989/relma/releases/download/v${RELMA_VERSION}/relma-linux-amd64.tar.gz \
 && tar xzf relma-linux-amd64.tar.gz \
 && install -m 0755 ./relma /usr/local/bin/relma

# lazygit
RUN wget -q https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
 && tar xf lazygit* \
 && install -m 0755 ./lazygit /usr/local/bin/

# ユーザを作成
ADD ./script/setup_user.sh /tmp/setup_user.sh
RUN bash /tmp/setup_user.sh
USER ${WORKUSER}
ENV HOME /home/${WORKUSER}

# dotfiles
WORKDIR ${HOME}
RUN git clone https://github.com/jiro4989/dotfiles \
 && cd dotfiles \
 && ./script/setup/link_config.sh \
 && relma init \
 && relma install -f ./conf/releases.json

ENV PATH=${PATH}:${HOME}/relma/bin

# Setup git
RUN git config --global user.name "${WORKUSER:-$USER}" \
 && git config --global user.email "${EMAIL}" \
 && git config --global alias.preq pull-request \
 && git config --global alias.see browse \
 && git config --global ghq.root ~/src

RUN $HOME/relma/bin/ghq get -P \
    jiro4989/sandbox \
    jiro4989/scripts \
    jiro4989/workspace \
    ;

# Fish
RUN curl https://git.io/fisher --create-dirs -sLo $HOME/.config/fish/functions/fisher.fish
RUN fish -c "fisher install edc/bass"
RUN fish -c "fisher install oh-my-fish/theme-clearance"
RUN fish -c "fisher install fisherman/z"

ENTRYPOINT ["tmux"]

FROM base as nim

USER root
RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    build-essential \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER ${WORKUSER}
WORKDIR /tmp

RUN wget -q https://nim-lang.org/choosenim/init.sh \
 && bash init.sh -y

RUN ghq get -P \
    jiro4989/faker \
    jiro4989/nimjson \
    jiro4989/websh \
    ;

WORKDIR ${HOME}

FROM base as go

ENV GO_VERSION=1.19
ENV PATH=${PATH}:/usr/local/go/bin

USER root
RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    ca-certificates \
    gcc \
    make \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local
RUN wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar xf go*.linux-amd64.tar.gz

USER ${WORKUSER}
RUN go install golang.org/x/tools/gopls@latest \
 && go install golang.org/x/tools/cmd/goimports@latest

RUN ghq get -P \
    jiro4989/textimg \
    jiro4989/ojosama \
    jiro4989/ojosama-web \
    ;

WORKDIR ${HOME}

FROM base as rust

RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    build-essential \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/install_rust.sh \
 && chmod +x /tmp/install_rust.sh \
 && /tmp/install_rust.sh -y \
 && which ${HOME}/.cargo/bin/cargo

# coc-rls の依存ライブラリ
RUN ${HOME}/.cargo/bin/rustup component add rls rust-analysis rust-src

RUN ghq get -P \
    jiro4989/suln \
    ;

FROM base as java

USER root

RUN add-apt-repository -y ppa:cwchien/gradle

RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    ca-certificates \
    falkon \
    gradle \
    xfce4 \
    xrdp \
    xterm \
    xvfb \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget -q "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz" \
 && tar xf OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz

ARG DIR=jdk-17.0.1+12

RUN mkdir -p /opt/java
RUN mv "$DIR/" /opt/java/
RUN ln -sfn "/opt/java/$DIR/" /opt/java/current

# GUI環境構築のためにRDPをセットアップする
ADD ./script/setup_rdp.sh /tmp/setup_rdp.sh
RUN bash /tmp/setup_rdp.sh

USER ${WORKUSER}

RUN ghq get -P \
    jiro4989/TKoolFacetileMaker2 \
    jiro4989/TKoolImageTileEditor \
    jiro4989/TKoolCharacterAnimationSimulator \
    jiro4989/MVTextEditor \
    ;

WORKDIR ${HOME}

FROM base as node

WORKDIR /tmp
USER ${WORKUSER}
ENV PATH=${HOME}/.nodenv/bin:${HOME}/.nodenv/shims:${PATH}
RUN wget -q https://raw.githubusercontent.com/nodenv/nodenv-installer/master/bin/nodenv-installer \
 && bash ./nodenv-installer
WORKDIR ${HOME}

RUN ghq get -P \
    jiro4989/setup-nim-action \
    jiro4989/jira_issue_url_generator \
    ;

FROM base as infra

USER root
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
 && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

RUN apt-get update -yqq \
 && apt-get upgrade -y \
 && apt-get install -y \
    ca-certificates \
    terraform-ls \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER ${WORKUSER}
RUN git config --global credential.helper 'store --file ~/.my-credentials'
