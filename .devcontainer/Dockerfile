ARG VARIANT=3.6-bullseye
FROM python:${VARIANT}
# shows secret from default secret location:
# RUN --mount=type=secret,id=mysecret \
#     values=$(cat /run/secrets/mysecret)\
#     && echo this is my $values
#Add packages and installs
#ENV DEBIAN_FRONTEND=noninteractive
# shows secret from default se

# Copy library scripts to execute
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/

# [Option] Install zsh
ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    # Install common packages, non-root user
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "false" "false" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Install .net and artifacts keyring to reach azure 
#https://docs.microsoft.com/en-us/dotnet/core/install/linux-debian#debian-11-
RUN apt-get update && apt-get install -y git && \
    wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update; \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y dotnet-sdk-6.0 && \
    pip install --upgrade pip && \
    pip install artifacts-keyring

ARG ARTIFACTS_KEYRING_NONINTERACTIVE_MODE
ENV ARTIFACTS_KEYRING_NONINTERACTIVE_MODE=true


#Make a default workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# install the packages from the private pypl artifacts server:
# Comment this section out if you don't want to use the private pypl artifacts server
# Fill in Organization with your azure devops organization name
# Fill in the feed with your azure devops artifacts feed name
# https://docs.microsoft.com/en-us/azure/devops/artifacts/quickstarts/python-cli?view=azure-devops
COPY requirements-private.txt .
RUN --mount=type=secret,id=azdevopstoken,dst=/run/secrets/azdevopstoken \
     pip install -i https://"$(cat /run/secrets/azdevopstoken)"@pkgs.dev.azure.com/<Organization>/_packaging/<Feed>/pypi/simple/ --no-cache-dir -r requirements-private.txt

# install dev packages
# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
COPY requirements-dev.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements-dev.txt \
   && rm -rf /tmp/pip-tmp

# install packages from public pypl
# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

# Set back to work
ENV DEBIAN_FRONTEND=dialog
# Set the default shell to bash rather than sh
ENV SHELL /bin/bash



 
     #https://pkgs.dev.azure.com/cgcRDClusterComputing/_packaging/callaway/pypi/simple