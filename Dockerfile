FROM ubuntu
ARG USER=docker
ARG UID=1000
ARG GID=1000
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get upgrade -y

RUN groupadd --gid ${GID} ${USER} && \
    useradd --create-home ${USER} --uid=${UID} --gid=${GID} --groups root && \
    passwd --delete ${USER}
RUN apt install -y sudo && \
    adduser ${USER} sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get install -y python3 python3-venv wget build-essential autotools-dev autoconf libusb-1.0-0 libusb-1.0-0-dev pkg-config git

RUN git clone https://github.com/riscv-mcu/gd32-dfu-utils.git

RUN cd gd32-dfu-utils && ./autogen.sh && ./configure && make && make install

USER ${UID}:${GID}
WORKDIR /home/${USER}

RUN wget https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py -O get-platformio.py && python3 get-platformio.py

ENV PATH "$PATH:/home/${USER}/.local/bin"

RUN mkdir -p /home/${USER}/.local/bin
RUN ln -s /home/${USER}/.platformio/penv/bin/platformio /home/${USER}/.local/bin/platformio && \
    ln -s /home/${USER}/.platformio/penv/bin/pio /home/${USER}/.local/bin/pio && \
    ln -s /home/${USER}/.platformio/penv/bin/piodebuggdb /home/${USER}/.local/bin/piodebuggdb

RUN mkdir -p /home/${USER}/workspace

WORKDIR /home/${USER}/workspace

SHELL [ "/usr/bin/bash", "-c" ]

CMD [ "/usr/bin/bash" ]