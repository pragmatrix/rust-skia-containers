# https://github.com/rust-skia/rust-skia/issues/535
FROM arm64v8/ubuntu:20.04
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

RUN apt-get update 

# Preinstall tzdata, so that it does not when installed as a transitive dependency later.
ENV TZ=Europe/Berlin
RUN DEBIAN_FRONTEND=noninteractive apt-get install tzdata

# unzip: for installing the Android NDK
# libgl1 libgl1-mesa-dev mesa-common-dev: for builds that need OpenGL
# libgles2-mesa-dev for egl support.
RUN apt-get install -y \
	curl \
	gcc \
	g++-10 \
	git \
	libgl1 \
	libgl1-mesa-dev \
	libgles2-mesa-dev \
	libssl-dev \
	libfontconfig1-dev \
	mesa-common-dev \
	pkg-config \
	python \
	clang \
	ninja.build

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

ENV SKIA_NINJA_COMMAND=/usr/bin/ninja

# Install Android NDK

#ENV ANDROID_NDK_VERSION=r21d
#ENV ANDROID_HOST=linux-x86_64

# We use HTTP/1.1, because of spurious HTTP/2 framing errors in the Azure / GitHub cloud.

#RUN curl --http1.1 -sSf -o android-ndk.zip https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-${ANDROID_HOST}.zip \
# && unzip android-ndk.zip \
# && rm android-ndk.zip

#ENV ANDROID_NDK=/android-ndk-${ANDROID_NDK_VERSION}
#ENV PATH=${PATH}:/android-ndk-${ANDROID_NDK_VERSION}/toolchains/llvm/prebuilt/${ANDROID_HOST}/bin

