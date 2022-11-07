# obs-teleport-docker

### Based off [bandi13/gui-docker](https://github.com/bandi13/gui-docker) <3

##
- Docker implementation of OBS with Teleport.

## Current status: Work In Progress

- Ubuntu 20.04
- Install latest version of OBS from Repo
- Installs [fzwoch/obs-teleport](https://github.com/fzwoch/obs-teleport) v0.6.1
- VNC server through web browser via noVNC (http://hostname:5901)
- 


## To Do

- Add websockets support using [Niek/obs-web](https://github.com/Niek/obs-web)
- GPU passthrough for NVENC,AMD and Intel QSV.
- Wrap it up in a nice lil' package


## Build

```
wget https://raw.githubusercontent.com/injnius/obs-teleport-docker/master/Dockerfile -O Dockerfile
```

```
docker build -t obs-teleport:latest .
```

```
docker run \
	--name obs-teleport \
	--detach \
	--network host \
	--env VNC_PASSWD="123456" \
	obs-teleport:latest
```

