FROM archlinux:multilib-devel AS builder

RUN useradd -m builduser

RUN echo "builduser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i -e '/^OPTIONS=/s/!debug/debug/' -e '/^OPTIONS=/s/debug/!debug/' /etc/makepkg.conf

RUN sed -i -e '/^OPTIONS=/s/!lto/lto/' -e '/^OPTIONS=/s/lto/!lto/' /etc/makepkg.conf

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git sudo

COPY ./dist/* /dist/

RUN find /dist/ -type f -name "*.pkg.tar.zst" -exec pacman --noconfirm -U {} \;

ARG PACKAGE_NAME

USER builduser

RUN git clone https://aur.archlinux.org/${PACKAGE_NAME}.git /tmp/package

WORKDIR /tmp/package

RUN makepkg -s --noconfirm

FROM scratch

COPY --from=builder /tmp/package/*.pkg.tar.zst /
