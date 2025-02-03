FROM quay.io/fedora/fedora-bootc:41

# Installing Software
RUN dnf -y install  neovim \
                    syncthing \
                    wireguard-tools \
                    netcat \
                    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} \
                    ruby-bundled-gems \
                    cockpit \
                    cockpit-{podman,selinux,storaged,networkmanager} \
                    ddclient

# Starting Cockpit
RUN systemctl enable cockpit.socket


# Configuring Syncthing.
# It is however not started by default as this will depend on the user.
COPY ./syncthing/syncthing-sysuser.conf  /usr/lib/sysusers.d
COPY ./syncthing/syncthing-tmpfiles.conf /usr/lib/tmpfiles.d
COPY ./syncthing/syncthing.service       /usr/lib/systemd/system
                    

# Configuring ddclient
COPY ./ddclient/ddclient-sysuser.conf  /usr/lib/sysusers.d
COPY ./ddclient/ddclient-tmpfiles.conf /usr/lib/tmpfiles.d


# Personlizing the os-name and default hostname
RUN echo VARIANT="Calyx" && echo VARIANT_ID=ch.ericst.calyx >> /usr/lib/os-release
RUN echo calyx > /etc/hostname


RUN bootc container lint

