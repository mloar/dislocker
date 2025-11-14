FROM alpine:latest AS build
WORKDIR /build

RUN apk update
RUN apk add build-base cmake fuse3-dev mbedtls-dev mbedtls-static pkgconf

COPY CMakeLists.txt .
COPY cmake cmake
COPY include include
COPY man man
COPY src src

RUN cmake --install-prefix=/usr .
RUN make preinstall

FROM alpine:latest
WORKDIR /build

RUN apk update
RUN apk add fuse3 mbedtls ntfs-3g

COPY --from=build /build/src/dislocker-bek /usr/bin
COPY --from=build /build/src/dislocker-metadata /usr/bin
COPY --from=build /build/src/dislocker-file /usr/bin
COPY --from=build /build/src/dislocker-fuse /usr/bin
COPY --from=build /build/src/libdislocker.so* /usr/lib

CMD ["sh"]
