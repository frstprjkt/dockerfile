FROM ubuntu:jammy

LABEL maintainer="Vayruz Rafli <vayruzrafli79@outlook.co.id>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Configure Java Virtual Machine (JVM).
ENV JAVA_OPTS=" -Xmx4G "
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Create new user.
RUN useradd -ms /bin/bash minerva

# Install all required packages.
RUN apt-get update -y
RUN apt-get install -y \
    adb android-sdk-platform-tools autoconf automake axel bc binutils bison \
    build-essential ccache clang cmake coreutils curl expat fastboot flex g++ \
    g++-multilib gawk gcc gcc-multilib git git-lfs gnupg gperf \
    htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev \
    libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev \
    libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils lld llvm '^lzma.*' lzop \
    maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
    pngquant python2.7 python-all-dev re2c schedtool squashfs-tools subversion \
    texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
    libxml-simple-perl libswitch-perl apt-utils \
    libncurses5 python-is-python3 ssh sudo openssl gnupg wget \
    rclone rsync aria2 ffmpeg ccache lsb-release tar apt-transport-https

# Install GitHub CLI.
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
RUN apt update
RUN apt install -y gh

# Install repo.
RUN curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
RUN chmod a+rx /usr/local/bin/repo

# Configure udev rules for ADB.
RUN curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
RUN chmod 644 /etc/udev/rules.d/51-android.rules
RUN chown root /etc/udev/rules.d/51-android.rules

# Set username.
USER minerva

# Set working directory.
WORKDIR /home/minerva

VOLUME ["/home/minerva"]
