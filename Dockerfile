FROM swift
WORKDIR /app
COPY . ./
ENV TELEGRAM_BOT_TOKEN=""
ENV BAA_URL=""
ENV BAA_USER_AGENT=""
CMD apt-get update && \
	apt-get install libcurl4-openssl-dev python3-pip -y && \
	pip3 install pillow && \
	swift package clean && \
	swift run
