FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y lttng-tools lttng-modules-dkms liblttng-ust-dev