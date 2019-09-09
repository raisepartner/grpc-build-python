ARG GRPC_BUILD_VERSION=latest

FROM raisepartner/grpc-build-cpp:${GRPC_BUILD_VERSION} as CPP

FROM python:3.7-buster

# install grpc
COPY --from=CPP /usr/local/lib/lib*.so.* /usr/local/lib/
COPY --from=CPP /usr/local/lib/lib*.so /usr/local/lib/
COPY --from=CPP /usr/local/include/* /usr/local/include/
COPY --from=CPP /usr/local/bin/protoc /usr/local/bin/

RUN pip install -U pip \
  && pip install grpcio grcio-tools

COPY pip.conf /etc/pip.conf
