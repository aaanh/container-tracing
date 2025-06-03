default: trace

build:
	docker build . -t ls-inst:latest --network=host

trace:
	export LD_PRELOAD=liblttng-ust-libc-wrapper.so:liblttng-ust-cyg-profile.so:ltng-ust-fork.so
	lttng create docker-both-ls
	lttng enable-event -u -a
	lttng enable-event -k -a
	lttng start
	-docker run ls-inst:latest
	lttng stop
	lttng destroy

clean-docker:
	docker container prune -f
	docker image prune -f