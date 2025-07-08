#!/bin/bash


function trace() {
	export LD_PRELOAD=liblttng-ust-cyg-profile.so:liblttng-ust-fork.so
	for i in {1..5}; do
		./ls -la
	done
}

trace