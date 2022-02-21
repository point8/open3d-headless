FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --yes \
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
    libssl-dev \
    libtool && \
    rm -rf /var/lib/apt/lists/*

# Pyenv
RUN wget -q -O - https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
ENV PATH=/root/.pyenv/bin/:$PATH
RUN pyenv install 3.9.7
RUN eval "$(pyenv virtualenv-init --path -)" && pyenv global 3.9.7
ENV PATH="/root/.pyenv/shims:${PATH}"
RUN pip install numpy

# Installing cmake 3.22
WORKDIR /root
RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-x86_64.sh && \
    sh ./cmake-3.22.2-linux-x86_64.sh --prefix=/ --exclude-subdir --skip-license
ENV PATH=/bin:$PATH

# Downloading open3D
RUN git clone https://github.com/isl-org/Open3D.git /open3d
RUN mkdir /open3d/build
WORKDIR /open3d/build
RUN git checkout v0.14.1
RUN echo "-DENABLE_HEADLESS_RENDERING=ON -DBUILD_WEBRTC=OFF -DBUILD_GUI=OFF -DUSE_SYSTEM_GLEW=OFF -DUSE_SYSTEM_GLFW=OFF -DPYTHON_EXECUTABLE=$(pyenv prefix)/bin/python -DBUILD_CUDA_MODULE=OFF -DBUILD_PYTORCH_OPS=OFF -DBUILD_TENSORFLOW_OPS=OFF -DBUNDLE_OPEN3D_ML=OFF -DCMAKE_BUILD_TYPE=Release" > cmake-flags.txt

RUN echo 'echo "To build Open3D run: cmake \$(cat cmake-flags.txt) .. && make -j4"' >> ~/.bashrc 
CMD /bin/bash
