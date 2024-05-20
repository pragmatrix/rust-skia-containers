# https://github.com/rust-skia/rust-skia/issues/535
FROM arm64v8/ubuntu:20.04
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

# For github actions we need a newer git version
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && add-apt-repository ppa:git-core/ppa -y

RUN apt-get install -y wget

## Add llvm package repository for ubuntu 20 (focal)
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main"

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

# aarch64 specific

RUN apt-get install -y \
	ninja.build

ENV SKIA_NINJA_COMMAND=/usr/bin/ninja

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 90 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-16 --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-16

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Android NDK

ENV ANDROID_NDK_VERSION=r26d
ENV ANDROID_HOST=linux-aarch64

# HTTP/1.1, because of spurious HTTP/2 framing errors in the Azure / GitHub cloud.

RUN curl --http1.1 -sSf -o android-ndk.zip https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip \
 && unzip android-ndk.zip \
 && rm android-ndk.zip

ENV ANDROID_NDK=/android-ndk-${ANDROID_NDK_VERSION}
ENV PATH=${PATH}:/android-ndk-${ANDROID_NDK_VERSION}/toolchains/llvm/prebuilt/${ANDROID_HOST}/bin

