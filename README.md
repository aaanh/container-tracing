# Tracing Docker container

...or with any engine, hopefully.

![](https://badgen.net/badge/status/proof%20of%20concept/purple?icon=github)

> ![WARNING]
> 
> Currently only tested on Linux.

## Pre-requisites

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

It is recommended that you verify that `lttng` is working as intended by running: 

- Userspace applications: `lttng list --userspace`
- Kernel: `lttng list --kernel`

Then, specifically for userspace applications, they only appear on the list if an instrumented process is running,
so you should run:

```sh
watch -n 0.5 'lttng list --userspace'
```

Build the Docker container image with the `build` target in the `Makefile`

```sh
make build
```

Finally, simply execute the default target in the `Makefile`

```sh
make
```

At the end of the rainbow, there should be a new trace folder in your `$(HOME)/lttng-traces` directory.

## Example traces

There's an [`example-traces`](./example-traces/) folder containing a kernel trace ready to view in Trace Compass.

Extract with

```sh
tar --lzma -xvf docker-kernel-ust.tar.lzma
```
