# This container is based on ubuntu 18 because we need to link with libstdc++ 6.0.25 because of ABI incompatibilities.
# <https://github.com/rust-skia/rust-skia/issues/393>
FROM ubuntu:18.04
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

# For github actions we need a newer git version
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:git-core/ppa -y

RUN apt-get install -y wget

## Add llvm package repository for ubuntu 18 (bionic)
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-16 main"

# unzip: for installing the Android NDK
# libgl1 libgl1-mesa-dev mesa-common-dev: for builds that need OpenGL
# libgles2-mesa-dev for egl support.
# clang-16 / g++-16 is needed for more recent emscripten builds.
RUN apt-get update && apt-get install -y \
	curl \
	gcc \
	g++-16 \
	git \
	libgl1 \
	libgl1-mesa-dev \
	libgles2-mesa-dev \
	libssl-dev \
	libfontconfig1-dev \
	mesa-common-dev \
	pkg-config \
	python \
	unzip

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 90 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-16 --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-16

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Android NDK

ENV ANDROID_NDK_VERSION=r26d
ENV ANDROID_HOST=linux-x86_64

# HTTP/1.1, because of spurious HTTP/2 framing errors in the Azure / GitHub cloud.

RUN curl --http1.1 -sSf -o android-ndk.zip https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip \
 && unzip android-ndk.zip \
 && rm android-ndk.zip

ENV ANDROID_NDK=/android-ndk-${ANDROID_NDK_VERSION}
ENV PATH=${PATH}:/android-ndk-${ANDROID_NDK_VERSION}/toolchains/llvm/prebuilt/${ANDROID_HOST}/bin

# Node 20

# <https://github.com/nodesource/distributions/issues/1392#issuecomment-1815887430>

# Start by installing Node 20:

RUN apt-get install -y python3 g++ make python3-pip gcc bison
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n 20

# Node 20 is now at /usr/local/bin/node, but glibc 2.28 is missing:
# node: /lib/aarch64-linux-gnu/libc.so.6: version `GLIBC_2.28' not found (required by node)
# /usr/local/bin/node: /lib/aarch64-linux-gnu/libc.so.6: version `GLIBC_2.28' not found (required by /usr/local/bin/node)

# Build and install glibc 2.28:
RUN apt install -y gawk
RUN	wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.28.tar.gz
RUN tar -zxf glibc-2.28.tar.gz
RUN cd glibc-2.28 && mkdir glibc-build
RUN cd glibc-2.28/glibc-build && ../configure --prefix=/opt/glibc-2.28
RUN cd glibc-2.28/glibc-build && make -j
RUN cd glibc-2.28/glibc-build && make install
RUN rm -fr glibc-2.28 glibc-2.28.tar.gz
	 
# Patch the installed Node 20 to work with /opt/glibc-2.28 instead: 
RUN apt install -y patchelf
RUN patchelf --set-interpreter /opt/glibc-2.28/lib/ld-linux-x86-64.so.2 --set-rpath /opt/glibc-2.28/lib/:/lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/ /usr/local/bin/node
# Et voilà:
# RUN /usr/local/bin/node --version

# wasm32-unknown-emscripten

SHELL ["/bin/bash", "-c"]

ENV EMSCRIPTEN_VER=3.1.59

RUN git clone https://github.com/emscripten-core/emsdk.git \
	&& (cd emsdk && ./emsdk install ${EMSCRIPTEN_VER}) \
	&& (cd emsdk && ./emsdk activate ${EMSCRIPTEN_VER})

# Needed for cross compilation to aarch64-unknown-linux-gnu
RUN apt-get install -y g++-aarch64-linux-gnu

