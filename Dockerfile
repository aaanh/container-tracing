FROM aaanh/lttng-base:latest

WORKDIR /app

COPY . .

CMD ["bash", "trace.sh"]
