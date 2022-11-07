FROM ubuntu:20.04
ARG DEBIAN_FRONTEND="noninteractive"
# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=123456
# Make sure the dependencies are met
RUN apt-get update \
	&& apt install -y tigervnc-standalone-server fluxbox xterm git net-tools python python-numpy scrot wget software-properties-common vlc module-init-tools avahi-daemon unzip \
	&& sed -i 's/geteuid/getppid/' /usr/bin/vlc \
	&& add-apt-repository ppa:obsproject/obs-studio \
	&& git clone --branch v1.0.0 --single-branch https://github.com/novnc/noVNC.git /opt/noVNC \
	&& git clone --branch v0.8.0 --single-branch https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify \
	&& ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html \
# Copy various files to their respective places
	&& wget -q -O /opt/container_startup.sh https://raw.githubusercontent.com/injnius/obs-teleport-docker/master/container_startup.sh \
	&& wget -q -O /opt/x11vnc_entrypoint.sh https://raw.githubusercontent.com/injnius/obs-teleport-docker/master/x11vnc_entrypoint.sh \
	&& mkdir -p /opt/startup_scripts \
	&& wget -q -O /opt/startup_scripts/startup.sh https://raw.githubusercontent.com/injnius/obs-teleport-docker/master/startup.sh
# Update apt for the new obs repository
RUN apt-get update \
	&& mkdir -p /config/obs-studio /root/.config/ \
	&& ln -s /config/obs-studio/ /root/.config/obs-studio \
	&& apt install -y ffmpeg obs-studio \
	&& apt-get clean -y \
# Download and install the plugins for NDI
    && 	&& wget -q -O /tmp/obs-teleport.zip https://github.com/fzwoch/obs-teleport/releases/download/0.6.1/obs-teleport.zip \
	&& unzip -qo /tmp/obs-teleport.zip -d /tmp/obs-teleport \
    && mkdir -p /root/.config/obs-studio/plugins/obs-teleport/bin/64bit \
    && cp /tmp/obs-teleport/linux-x86_64/obs-teleport.so /root/.config/obs-studio/plugins/obs-teleport/bin/64bit/obs-teleport.so \
	&& rm -rf /tmp/obs-teleport \
	&& rm -rf /var/lib/apt/lists/* \
	&& chmod +x /opt/*.sh \
	&& chmod +x /opt/startup_scripts/*.sh 
	 
# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"OBS Screencast\" command=\"obs\"" >> /usr/share/menu/custom-docker \
	&& echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus
VOLUME ["/config"]
ENTRYPOINT ["/opt/container_startup.sh"]