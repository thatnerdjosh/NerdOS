FROM archlinux

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm       \ 
        base-devel              \
        patch                   \
        python3                 \
        wget                 && \
    mkdir -p /opt/NerdOS

COPY . /opt/NerdOS
WORKDIR /opt/NerdOS
