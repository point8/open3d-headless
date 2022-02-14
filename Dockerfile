FROM ubuntu:18.04

RUN apt update
RUN apt install --yes \
    git \
    wget \
    python3.6 \
    python3-pip \
    libosmesa6-dev \
    xorg-dev \
    libglu1-mesa-dev \
    python3-dev \
    libsdl2-dev \
    libc++-7-dev \
    libc++abi-7-dev \
    ninja-build \
    libxi-dev \
    libtbb-dev \
    libosmesa6-dev \
    libudev-dev \
    autoconf \
    libtool && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install numpy
RUN git clone https://github.com/isl-org/Open3D.git /open3d
# Installing cmake 3.22
WORKDIR /root
RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-x86_64.sh && \
    sh ./cmake-3.22.2-linux-x86_64.sh --prefix=/ --exclude-subdir --skip-license
ENV PATH=/bin:$PATH
RUN cmake --version
RUN mkdir /open3d/build
WORKDIR /open3d/build
# RUN cmake -DENABLE_HEADLESS_RENDERING=ON \
#     -DBUILD_GUI=OFF \
#     -DUSE_SYSTEM_GLEW=OFF \
#     -DUSE_SYSTEM_GLFW=OFF \
#     ..
# RUN make -j8
CMD /bin/bash
