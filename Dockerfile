ARG GRPC_BUILD_VERSION=latest

FROM raisepartner/grpc-build-cpp:${GRPC_BUILD_VERSION} as CPP

FROM python:3.7-buster

# install grpc
COPY --from=CPP /usr/local/lib/libgrpc*.so.*.* /usr/local/lib/
COPY --from=CPP /usr/local/lib/libproto*.so.*.* /usr/local/lib/
COPY --from=CPP /usr/local/lib/libproto*.a /usr/local/lib/
COPY --from=CPP /usr/local/lib/libproto*.la /usr/local/lib/
COPY --from=CPP /usr/local/include/* /usr/local/include/
COPY --from=CPP /usr/local/bin/* /usr/local/bin/

# HACK: re-create symlinks for grpc libs (COPY would break ld)
RUN cd /usr/local/lib/ \
  && ln -s libgrpc++.so.1.20.0 libgrpc++.so.1 \
  && ln -s libgrpc++.so.1.20.0 libgrpc++.so \
  && ln -s libgrpc++_cronet.so.1.20.0 libgrpc++_cronet.so.1 \
  && ln -s libgrpc++_cronet.so.1.20.0 libgrpc++_cronet.so \
  && ln -s libgrpc++_error_details.so.1.20.0 libgrpc++_error_details.so.1 \
  && ln -s libgrpc++_error_details.so.1.20.0 libgrpc++_error_details.so \
  && ln -s libgrpc++_reflection.so.1.20.0 libgrpc++_reflection.so.1 \
  && ln -s libgrpc++_reflection.so.1.20.0 libgrpc++_reflection.so \
  && ln -s libgrpc++_unsecure.so.1.20.0 libgrpc++_unsecure.so.1 \
  && ln -s libgrpc++_unsecure.so.1.20.0 libgrpc++_unsecure.so \
  && ln -s libgrpc.so.7.0.0 libgrpc.so.7 \
  && ln -s libgrpc.so.7.0.0 libgrpc.so \
  && ln -s libgrpc_cronet.so.7.0.0 libgrpc_cronet.so.7 \
  && ln -s libgrpc_cronet.so.7.0.0 libgrpc_cronet.so \
  && ln -s libgrpc_unsecure.so.7.0.0 libgrpc_unsecure.so.7 \
  && ln -s libgrpc_unsecure.so.7.0.0 libgrpc_unsecure.so \
  && ln -s libgrpcpp_channelz.so.1.20.0 libgrpcpp_channelz.so.1 \
  && ln -s libgrpcpp_channelz.so.1.20.0 libgrpcpp_channelz.so \
  && ln -s libprotobuf-lite.so.18.0.0 libprotobuf-lite.so.18 \
  && ln -s libprotobuf-lite.so.18.0.0 libprotobuf-lite.so \
  && ln -s libprotobuf.so.18.0.0 libprotobuf.so.18 \
  && ln -s libprotobuf.so.18.0.0 libprotobuf.so \
  && ln -s libprotoc.so.18.0.0 libprotoc.so.18 \
  && ln -s libprotoc.so.18.0.0 libprotoc.so \
  && ldconfig

RUN pip install -U pip \
  && pip install grpcio grpcio-tools

COPY pip.conf /etc/pip.conf
