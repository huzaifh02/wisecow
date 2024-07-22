FROM ubuntu:latest

#Installing Dependencies
RUN apt-get update && \
    apt-get install -y fortune cowsay netcat-openbsd && \
    apt-get clean

COPY wisecow.sh /wisecow.sh

RUN chmod +x /wisecow.sh

EXPOSE 4499

ENTRYPOINT ["/wisecow.sh"]
