FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    gdb \
    cmake \
    git \
    bash \
    sudo \
    nano \
    tree \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN useradd -ms /bin/bash vscode && \
    echo "vscode:vscode" | chpasswd && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

EXPOSE 22

WORKDIR /workspace

CMD ["/usr/sbin/sshd", "-D"]
