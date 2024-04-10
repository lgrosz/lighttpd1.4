FROM alpine:latest
RUN apk --no-cache add openssl
COPY intermediate.cnf /intermediate.cnf
COPY generate-keys.sh /generate-keys.sh
RUN chmod +x /generate-keys.sh
RUN mkdir /server /client
CMD ["/generate-keys.sh"]
