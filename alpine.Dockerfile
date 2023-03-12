FROM alpine:3.17

ENV TZ=Europe/London

RUN apk add -q --update --progress --no-cache \
  curl \
  docker-cli \
  exa \
  git \
  libstdc++ \
  openssh-client \
  starship \
  tmux \
  tzdata \
  vim \
  zoxide \
  zsh

WORKDIR /root/.files
COPY . .
RUN chmod +x setup.sh && ./setup.sh

ENTRYPOINT [ "/bin/zsh" ]
