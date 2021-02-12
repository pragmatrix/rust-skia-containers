# Use .NET 4.8 (otherwise a reboot may be required when installing build tools)
# Use ltsc2019 (saves about 5GB compared to a full Windows) and to hope we can
# be stable for a while. ltsc2019 is Windows 10 Version 1809
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019
LABEL org.opencontainers.image.source https://github.com/pragmatrix/rust-skia-containers

# no powershell by defaut
SHELL ["cmd", "/S", "/C"]

COPY arial.ttf C:/Windows/Fonts/
# Taken from the image: mcr.microsoft.com/windows:1809 
COPY opengl32.dll glu32.dll C:/Windows/System32/

RUN powershell -Command 'Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -name "Arial (TrueType)" -value "arial.ttf" -type STRING'

# https://github.com/StefanScherer/dockerfiles-windows/blob/main/chocolatey/Dockerfile
RUN powershell -Command \
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress

# git.install: we need bash.exe to run certain scripts on azure
# rustup: checksums do not match
RUN choco install -y git.install --params "/GitAndUnixToolsOnPath" \
    && choco install -y python2 --version 2.7.18 \
    && choco install -y llvm --version 11.0.0 \
    && choco install -y rust-ms --version 1.50.0 \
    && choco install -y rustup.install --version 1.22.1 --ignore-checksums \
    && choco install -y visualstudio2019buildtools --version 16.8.3 \
       --package-parameters "--nocache --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended" \
	&& rmdir "C:\ProgramData\Package Cache" /s /q \
	&& rmdir "C:\Users\ContainerAdministrator\AppData\Local\Temp\chocolatey" /s /q

# Install CA certs, otherwise python won't be able to access some web sites
# https://bugs.python.org/msg336806 
RUN certutil -generateSSTFromWU roots.sst && certutil -addstore -f root roots.sst && del roots.sst

