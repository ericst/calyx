FROM quay.io/fedora/fedora-bootc:41
# Customization steps

RUN dnf -y install  neovim \
                    syncthing \
                    wireguard-tools \
                    rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} \
                    ruby-bundled-gems \
                    cockpit \
                    cockpit-{podman,selinux,storaged,networkmanager}


                    
                    


RUN bootc container lint

