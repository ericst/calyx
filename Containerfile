FROM quay.io/fedora/fedora-bootc:41

# Installing Base Software
RUN dnf -y install  neovim \
                    git \
                    wireguard-tools \
                    netcat \
                    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} \
                    ruby-bundled-gems \
                    firewalld \
                    wget \
                    curl


# Installing and starting cockpit
RUN dnf -y install  cockpit \
                    cockpit-{podman,selinux,storaged,networkmanager}
RUN systemctl enable cockpit.socket
#RUN firewall-cmd --add-service=cockpit --permanent


# Installing and configuring Syncthing.
# It is however not started by default as this will depend on the user.
RUN dnf -y install syncthing
COPY ./syncthing/syncthing-sysuser.conf  /usr/lib/sysusers.d
COPY ./syncthing/syncthing-tmpfiles.conf /usr/lib/tmpfiles.d
COPY ./syncthing/syncthing.service       /usr/lib/systemd/system
                    

# Installing and configuring ddclient
RUN dnf -y install ddclient
COPY ./ddclient/ddclient-sysuser.conf  /usr/lib/sysusers.d
COPY ./ddclient/ddclient-tmpfiles.conf /usr/lib/tmpfiles.d

# Installing and configuring headscale
ARG HEADSCALE_VERSION="0.25.0"
RUN dnf -y install tailscale
RUN wget --output-document=/usr/local/bin/headscale \
                    https://github.com/juanfont/headscale/releases/download/v${HEADSCALE_VERSION}/headscale_${HEADSCALE_VERSION}_linux_amd64
RUN chmod +x /usr/local/bin/headscale
COPY ./headscale/headscale-sysuser.conf  /usr/lib/sysusers.d
COPY ./headscale/headscale-tmpfiles.conf /usr/lib/tmpfiles.d
RUN mkdir -p /etc/headscale
COPY ./headscale/config.yaml /etc/headscale
COPY ./headscale/headscale.service /etc/systemd/system


# Personlizing the os-name and default hostname
RUN echo VARIANT="Calyx" && echo VARIANT_ID=ch.ericst.calyx >> /usr/lib/os-release
RUN echo calyx > /etc/hostname


RUN bootc container lint

