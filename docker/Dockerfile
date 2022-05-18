FROM ubuntu:22.04 as base

ARG WORKUSER=jiro4989

ENV DEBIAN_FRONTEND=noninteractive
ENV SHFMT_VERSION=3.0.1
ENV DIRENV_VERSION=2.21.3
ENV RELMA_VERSION=1.4.0

RUN apt-get update -yqq \
 && apt-get install -y \
    software-properties-common \
    ca-certificates \
    curl \
    ;

RUN add-apt-repository -y ppa:lazygit-team/release \
 && add-apt-repository -y ppa:cwchien/gradle \
 && add-apt-repository -y ppa:git-core/ppa

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
 && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

RUN apt-get update -yqq \
 && apt-get install -y \
    ctop \
    docker.io \
    fish \
    git \
    htop \
    lazygit \
    shellcheck \
    tmux \
    unzip \
    vim \
    wget \
    \
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
RUN wget -q https://github.com/jiro4989/relma/releases/download/v${RELMA_VERSION}/relma-linux-amd64.tar.gz \
 && tar xzf relma-linux-amd64.tar.gz \
 && install -m 0755 ./relma /usr/local/bin/relma

# dotfiles
WORKDIR /home/${WORKUSER}
RUN git clone https://github.com/jiro4989/dotfiles \
 && cd dotfiles \
 && ./script/setup/link_config.sh \
 && relma init \
 && relma install -f ./conf/releases.json

# Setup git
RUN git config --global user.name "${WORKUSER:-$USER}" \
 && git config --global user.email "${WORKUSER:-$USER}" \
 && git config --global alias.preq pull-request \
 && git config --global alias.see browse \
 && git config --global ghq.root ~/src

RUN ghq get -P \
    jiro4989/sandbox \
    jiro4989/scripts \
    jiro4989/workspace \
    ;

# デフォルトシェルをtmuxに変更
RUN chsh -s "$(command -v tmux)" "${WORKUSER:-$USER}"

# fishのプラグインを追加
RUN fish -c "fisher install edc/bass"
RUN fish -c "fisher install oh-my-fish/theme-clearance"
RUN fish -c "fisher install fisherman/z"

FROM base as nim

WORKDIR /tmp

RUN wget -q https://nim-lang.org/choosenim/init.sh \
 && bash init.sh -y

RUN ghq get -P \
    jiro4989/faker \
    jiro4989/nimjson \
    jiro4989/websh \
    ;

FROM base as go

ENV GO_VERSION=1.18.2
ENV PATH=${PATH}:/usr/local/go/bin

WORKDIR /usr/local
RUN wget -q https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar xzf go*.linux-amd64.tar.gz
RUN go install golang.org/x/tools/gopls@latest \
 && go install golang.org/x/tools/cmd/goimports@latest

RUN ghq get -P \
    jiro4989/textimg \
    ;

FROM base as java

RUN apt-get update -yqq \
 && apt-get install -y \
    ca-certificates \
    gradle \
    xfce4 \
    xrdp \
    xvfb \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget -q "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz" \
 && tar xf OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz

ENV DIR=jdk-17.0.1+12

RUN mkdir -p /opt/java
RUN mv $DIR/ /opt/java/
RUN ln -sfn /opt/java/$DIR/ /opt/java/current

# GUI環境構築のためにRDPをセットアップする
ADD ./script/setup_rdp.sh /tmp/setup_rdp.sh
RUN bash /tmp/setup_rdp.sh

RUN ghq get -P \
    jiro4989/TKoolFacetileMaker2 \
    jiro4989/TKoolImageTileEditor \
    jiro4989/TKoolCharacterAnimationSimulator \
    jiro4989/MVTextEditor \
    ;

FROM base as node

RUN apt-get update -yqq \
 && apt-get install -y \
    ca-certificates \
    npm \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget -q https://raw.githubusercontent.com/nodenv/nodenv-installer/master/bin/nodenv-installer \
 && bash ./nodenv-installer

FROM base as infra

RUN apt-get update -yqq \
 && apt-get install -y \
    ca-certificates \
    python3 \
    python3-pip \
    terraform-ls \
    \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
