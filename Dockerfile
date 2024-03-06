FROM python AS build

ARG TAG=latest
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    pip wheel --wheel-dir=/whl mitmproxy==${TAG} && \
    find /root/.cache/pip/wheels -type f -name "*.whl" -exec cp {} /whl \;

FROM python:slim

COPY --from=build /whl /whl
RUN pip --no-cache-dir install --no-index --find-links=/whl mitmproxy && \
    rm -rf /whl
EXPOSE 8080 8081
CMD [ "mitmproxy" ]
