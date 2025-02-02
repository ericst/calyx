FROM quay.io/fedora/fedora-bootc:41

# Installing Software
RUN dnf -y install  neovim \
                    syncthing \
                    wireguard-tools \
                    netcat \
                    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} \
                    ruby-bundled-gems \
                    cockpit \
                    cockpit-{podman,selinux,storaged,networkmanager}

# Cockpit
RUN systemctl enable cockpit.socket


# Configuring syncthing
COPY ./syncthing/syncthing-sysuser.conf  /usr/lib/sysusers.d
COPY ./syncthing/syncthing-tmpfiles.conf /usr/lib/tmpfiles.d
COPY ./syncthing/syncthing.service       /etc/systemd/system
RUN systemctl enable syncthing
                    


RUN bootc container lint

