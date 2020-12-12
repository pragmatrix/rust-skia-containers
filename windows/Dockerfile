# We use windows server, because of the script execution policies on regular windows images.
FROM mcr.microsoft.com/windows/servercore:ltsc2019
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

# https://github.com/StefanScherer/dockerfiles-windows/blob/main/chocolatey/Dockerfile

RUN powershell -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress
RUN choco install -y python2 --version 2.7.18
RUN choco install -y llvm --version 11.0.0
RUN choco install -y rust-ms --version 1.48.0
RUN choco install -y visualstudio2019buildtools --version 16.8.3 \
    --ignore-package-exit-codes=3010 --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools"

