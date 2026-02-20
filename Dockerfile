FROM archlinux:latest AS builder

RUN useradd -m builduser

RUN echo "builduser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git sudo

ARG PACKAGE_NAME

USER builduser

RUN git clone https://aur.archlinux.org/${PACKAGE_NAME}.git /tmp/package

WORKDIR /tmp/package

RUN makepkg -s --noconfirm

FROM scratch

COPY --from=builder /tmp/package/*.pkg.tar.zst /
