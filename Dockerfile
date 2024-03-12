FROM python AS build

ARG TAG=latest
RUN PATH="/root/.cargo/bin:${PATH}" && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    pip wheel --wheel-dir=/wheels mitmproxy$([[ ${TAG} != "latest" ]] && echo "==${TAG}" || echo "") && \
    find /root/.cache/pip/wheels -type f -name "*.whl" -exec cp {} /wheels \;

FROM python:slim

COPY --from=build /wheels /wheels
RUN pip --no-cache-dir install --no-index --find-links=/wheels mitmproxy && \
    rm -rf /wheels
EXPOSE 8080 8081
CMD [ "mitmproxy" ]
