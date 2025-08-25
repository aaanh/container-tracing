# Containers Trace

![](https://badgen.net/badge/status/proof%20of%20concept/purple?icon=github)

> [!NOTE]
> 
> Currently only tested on Linux.
>
> Append `-podman` to `make` targets to use `podman` instead.

## Pre-requisites

This PoC assumes you already have Docker and/or Podman installed.

> [!NOTE]
>
> Since this traces both the userspace and kernel, you'll need root permission for lttng-sessiond + running as root or `sudo`/`doas`

- Trace Compass \[ [Download](https://projects.eclipse.org/projects/tools.tracecompass/downloads) \]
- Docker Engine \[ [Install](https://docs.docker.com/engine/install/) \]
  - Add your user account to the `docker` group after installation
  ```sh
  usermod -aG docker $(whoami)
  newgrp docker # or log out and log back in again, 
                # this will only start a new shell with the updated group permission
  ```
- lttng \[ [Install](https://lttng.org/download/) \]
  - Note that `lttng` kernel trace requires additional configurations to work.
- Build tools (specifically `make` for automation)

  - Ubuntu/Debian/Mint

  ```sh
  sudo apt install build-essential
  ```

  - Fedora/RHEL/CentOS

  ```sh
  sudo dnf group install "development-tools"
  ```

## Usage

### Before anything

It is recommended that you verify that `lttng` is working as intended by running: 

```sh
make sanity
```

Then verify that there are traces output to this repository's root `./lttng-traces`. And verify that you are able to view the traces in Trace Compass by importing those trace folders.


### Generate the traces

> [!NOTE]
>
> You should run `make` with `-i` option so that the trace sessions are sure to be stopped and deleted. Or else you'll end up like me: exhausted RAM and hard drive after a few minutes.

tl;dr

a. Docker

```sh
make all
```

b. Podman

```sh
make all-podman
```

This will `build`, `trace`, and `copy` the traces output to `{PROJECT_ROOT}/lttng-traces`.

To run each target separately, simply do:

```sh
make build
make trace
make copy
```

The default target is `trace` only.

```sh
make # with no target specified
```

## Dissecting the `Makefile`

### Building

- We build can optionally build and store locally a base image that is pre-installed with the various lttng packages. See <lttng-base.Dockerfile>
- We then build locally the Docker image loaded with the instrumented `ls` binary. See <Dockerfile>.
- Inside the container, `trace.sh` script is executed which then will call the instrumented `ls` for a set number of time. See <trace.sh>
  - Note that `trace.sh` exports `LD_PRELOAD` without the libc-wrapper, since it segfaults the `ls` program inside the container.

### Tracing

On the host machine, we export `LD_PRELOAD` with the necessary shared objects. Then, we execute the usual lttng commands to create a session, enable events, add context, and start the trace.

We then run the docker image and stop the trace and destroy the session immediately after.

Finally, for brevity, we change the permission (since it's made by root) of the trace folder and copy that to project working directory.

### Clean up

> [!WARNING]
> This will nuke all your containers and images. So, only run it if you're testing in PoC in an isolated environment.

- Prune the none-running containers and images.
  ```sh
  make clean-docker
  ```

- Wipe root's trace output folder
  ```sh
  make clean
  ```

## Roadmap

- [x] Docker trace
- [x] Podman trace
- [ ] Singularity trace