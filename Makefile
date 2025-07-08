default: trace

build-base:
	docker build . -f lttng-base.Dockerfile -t aaanh/lttng-base:latest --network=host --no-cache

build:
	docker build . -t ls-inst:latest --network=host --no-cache

trace:
	export LD_PRELOAD=liblttng-ust-libc-wrapper.so:liblttng-ust-cyg-profile.so:liblttng-ust-fork.so
	sudo lttng create "docker-both-ls-$(shell date +%Y%m%d-%H%M%S)"
	sudo lttng enable-event -u -a
	sudo lttng enable-event -k -a
	sudo lttng add-context -u -t vtid -t procname -t vpid -t ip
	sudo lttng start
	sudo docker run --rm \
		--ipc=host \
		-v /dev/shm:/dev/shm \
		-v /var/run/lttng:/var/run/lttng \
		ls-inst:latest
	sudo lttng stop
	sudo lttng destroy

clean-docker:
	docker container prune -f
	docker image prune -f

all: build trace copy

copy:
	mkdir -p lttng-traces
	sudo chmod 777 -R /root/lttng-traces
	sudo rsync -avPh /root/lttng-traces/ ./lttng-traces

clean:
	sudo rm -rf /root/lttng-traces

# Sanity check, use this to make sure that the trace is working on the host
sanity:
	lttng create "ls-$(shell date +%Y%m%d-%H%M%S)"
	lttng enable-event -u -a
	lttng add-context -u -t vtid -t procname -t vpid -t ip
	lttng start
	LD_PRELOAD=liblttng-ust-libc-wrapper.so:liblttng-ust-cyg-profile.so:liblttng-ust-fork.so ./ls -a
	lttng stop
	lttng destroy
	mkdir -p ./lttng-traces
	cp -r ~/lttng-traces/* ./lttng-traces/