FROM rust:slim-bookworm as starship-downloader

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /usr/scripts
RUN curl -sS -o starship.sh  https://starship.rs/install.sh && \
    chmod +x starship.sh && \
    ./starship.sh -y


FROM debian:bookworm-slim

ENV TZ=Europe/London

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    docker-ce-cli \
    exa \
    git \
    locales \
    openssh-client \
    tmux \
    tzdata \
    vim \
    zoxide \
    zsh && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=starship-downloader /usr/local/bin/starship /usr/bin/

RUN echo "LC_ALL=en_GB.UTF-8" >> /etc/environment && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_GB.UTF-8" > /etc/locale.conf && \
    locale-gen en_GB.UTF-8

WORKDIR /root/.files
COPY . .
RUN chmod +x setup.sh && ./setup.sh
RUN chsh -s /bin/zsh

ENTRYPOINT [ "/bin/zsh" ]
