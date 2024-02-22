FROM octoprint/octoprint:latest

WORKDIR /
ENV HOME /home/root

RUN git clone https://github.com/Klipper3d/klipper && \
    apt-get install --yes --force-yes systemctl virtualenv python-dev \
    libffi-dev build-essential libncurses-dev libusb-dev avrdude gcc-avr \
    binutils-avr avr-libc stm32flash libnewlib-arm-none-eabi gcc-arm-none-eabi  \
    binutils-arm-none-eabi libusb-1.0 pkg-config

WORKDIR /klipper

COPY install-debian.sh ./scripts/install-debian.sh

RUN  virtualenv -p python2 ${HOME}/klippy-env

COPY pyenv.cfg ${HOME}/klippy-env/pyvenv.cfg

RUN chmod 777 ./scripts/install-debian.sh && sh ./scripts/install-debian.sh