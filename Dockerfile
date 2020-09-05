FROM ubuntu:18.04
# unzip: for installing the Android NDK
RUN apt-get update && apt-get install -y \
	curl \
	gcc \
	g++-9 \
	git \
	libssl-dev \
	libfontconfig1-dev \
	pkg-config \
	python \
	unzip
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 90 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-9 --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-9
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo --version
RUN clang --version

