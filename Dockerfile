FROM rust:latest AS build

ARG TAG=latest
RUN apt-get update && apt-get install -y python3-pip python3-wheel
RUN pip wheel --wheel-dir=/whl mitmproxy==${TAG}
RUN find /root/.cache/pip/wheels -type f -name "*.whl" -exec cp {} /whl \;

FROM python:slim

COPY --from=build /whl /whl
RUN pip install --no-index --find-links=/whl mitmproxy
RUN rm -rf /whl
EXPOSE 8080 8081
ENTRYPOINT ["mitmproxy"]