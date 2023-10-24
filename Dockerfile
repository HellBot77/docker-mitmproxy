FROM rust:latest AS build

ARG TAG=latest
RUN apt-get update
RUN pip install wheel && pip wheel --wheel-dir /whl mitmproxy==${TAG}

FROM python:slim

RUN apt-get update
COPY --from=build /whl /whl
RUN pip install --no-index --find-links=/whl mitmproxy
RUN rm -rf /whl
EXPOSE 8080 8081
ENTRYPOINT ["mitmproxy"]