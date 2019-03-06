#FROM mhart/alpine-node:latest
FROM arm64v8/node:alpine

COPY --from=resin/aarch64-alpine:latest ["/usr/bin/qemu*", "/usr/bin/resin-xbuild*", "/usr/bin/cross-build*",  "/usr/bin/"]

RUN [ "cross-build-start" ]

ADD src/ /root/

RUN apk add --update unzip wget supervisor nano 

RUN mv /root/supervisord.conf /etc/supervisord.conf && \
	mkdir /app /config && \
	wget --no-check-certificate https://github.com/onedr0p/telegram-sonarr-bot/archive/master.zip -P /app && \
	unzip /app/master.zip -d /app && \
	rm /app/master.zip

RUN cd /app/telegram-sonarr-bot-master && npm install

RUN apk del unzip wget

RUN [ "cross-build-end" ]

VOLUME /config

CMD ["/bin/ash","/root/startup.sh"]
