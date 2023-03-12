FROM rust:slim-bookworm as exa-builder

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  cmake \
  git \
  libgit2-dev && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

ARG EXA_VERSION=0.10.1
RUN cargo install --version ${EXA_VERSION} exa


FROM rust:slim-bookworm as starship-builder

RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  cmake \
  git \
  libgit2-dev \
  make && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

ARG STARSHIP_VERSION=1.13.1
RUN cargo install --version ${STARSHIP_VERSION} starship


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
  git \
  openssh-client \
  tmux \
  tzdata \
  vim \
  zoxide \
  zsh && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=exa-builder /usr/local/cargo/bin/exa /usr/bin/
COPY --from=starship-builder /usr/local/cargo/bin/starship /usr/bin/

WORKDIR /root/.files
COPY . .
RUN chmod +x setup.sh && ./setup.sh
RUN chsh -s /bin/zsh

ENTRYPOINT [ "/bin/zsh" ]
