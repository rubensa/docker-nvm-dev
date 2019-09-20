FROM rubensa/ubuntu-dev
LABEL author="Ruben Suarez <rubensa@gmail.com>"

# Define nvm group id's
ARG NVM_GROUP_ID=2000

# Define nvm group and installation folder
ENV NVM_GROUP=nvm NVM_INSTALL_DIR=/opt/nvm

# Tell docker that all future commands should be run as root
USER root

# Set root home directory
ENV HOME=/root

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    # 
    # Install ACL
    && apt-get -y install acl \
    # 
    # Install zip
    && apt-get -y install zip unzip \
    #
    # Create nvm group
    && addgroup --gid ${NVM_GROUP_ID} ${NVM_GROUP} \
    #
    # Assign nvm group to non-root user
    && usermod -a -G ${NVM_GROUP} ${DEV_USER} \
    #
    # Install nvm
    && mkdir -p ${NVM_INSTALL_DIR} \
    && export NVM_DIR=${NVM_INSTALL_DIR} \
    && curl -o ~/nvm.sh "https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh" \
    && /bin/bash -l ~/nvm.sh --no-use \
    && rm ~/nvm.sh \
    #
    # Assign nvm group folder ownership
    && chgrp -R ${NVM_GROUP} ${NVM_INSTALL_DIR} \
    #
    # Set the segid bit to the folder
    && chmod -R g+s ${NVM_INSTALL_DIR} \
    #
    # Give write acces to the group
    && chmod -R g+wX ${NVM_INSTALL_DIR} \
    #
    # Set ACL to files created in the folder
    && setfacl -d -m u::rwX,g::rwX,o::r-X ${NVM_INSTALL_DIR} \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

# Tell docker that all future commands should be run as the non-root user
USER ${DEV_USER}

# Set user home directory (see: https://github.com/microsoft/vscode-remote-release/issues/852)
ENV HOME /home/$DEV_USER

# Configure conda for the non-root user
RUN printf "\n. ${NVM_INSTALL_DIR}/nvm.sh\n" >> ~/.bashrc
