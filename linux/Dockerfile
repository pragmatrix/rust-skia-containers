FROM ubuntu:18.04
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers
# unzip: for installing the Android NDK
# libgl1 libgl1-mesa-dev mesa-common-dev: for builds that need OpenGL
RUN apt-get update && apt-get install -y \
	curl \
	gcc \
	g++-9 \
	git \
	libgl1 \
	libgl1-mesa-dev \
	libssl-dev \
	libfontconfig1-dev \
	mesa-common-dev \
	pkg-config \
	python \
	unzip
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 90 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-9 --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-9
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
