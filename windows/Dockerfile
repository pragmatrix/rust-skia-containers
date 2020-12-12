# We use windows server, because of the script execution policies on regular windows images.
# FROM mcr.microsoft.com/windows/servercore:ltsc2019
# Use .NET 4.8 (otherwise a reboot may be required when installing build tools)
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

# no powershell by defaut
SHELL ["cmd", "/S", "/C"]

# https://github.com/StefanScherer/dockerfiles-windows/blob/main/chocolatey/Dockerfile
RUN powershell -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress

# git.install: we need bash.exe to run certain scripts on azure
RUN choco install -y git.install --params "/GitAndUnixToolsOnPath" \
    && choco install -y python2 --version 2.7.18 \
    && choco install -y llvm --version 11.0.0 \
    && choco install -y rust-ms --version 1.48.0 \
    && choco install -y visualstudio2019buildtools --version 16.8.3 \
       --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools;includeRecommended"

# Install CA certs, otherwise python won't be able to access some web sites
# https://bugs.python.org/msg336806 
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

