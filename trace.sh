#!/bin/bash

export LD_PRELOAD=liblttng-ust-libc-wrapper.so:liblttng-ust-fork.so:liblttng-ust-cyg-profile.so

for i in {1..10}; do
	./ls -la
done
