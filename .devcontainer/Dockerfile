FROM inet-framework/omnetpp:6.0

# Cài thêm các công cụ cần thiết cho Codespace
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Tạo user vscode (bắt buộc cho Codespace)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Kích hoạt OMNeT++ khi vào container
RUN echo 'source /usr/local/omnetpp-6.0/setenv' >> ~/.bashrc
