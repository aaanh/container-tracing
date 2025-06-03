FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y lttng-tools lttng-modules-dkms liblttng-ust-dev

WORKDIR /app

COPY . .

ENV LD_PRELOAD=liblttng-ust-cyg-profile.so:liblttng-ust-fork.so:liblttng-ust-libc-wrapper.so

CMD ["bash", "trace.sh"]
