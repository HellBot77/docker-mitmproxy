FROM python:latest AS build

ARG TAG=latest
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN pip wheel --wheel-dir=/whl mitmproxy==${TAG}
RUN find /root/.cache/pip/wheels -type f -name "*.whl" -exec cp {} /whl \;

FROM python:alpine

COPY --from=build /whl /whl
RUN pip install --no-index --find-links=/whl mitmproxy
RUN rm -rf /whl
EXPOSE 8080 8081
ENTRYPOINT ["mitmproxy"]