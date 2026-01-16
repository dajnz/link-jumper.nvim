###
# Most of the code was taken from: https://github.com/lunarmodules/busted/blob/master/Dockerfile
###

FROM akorn/luarocks:lua5.4-alpine AS builder

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing dumb-init gcc libc-dev git \
    && git clone https://github.com/lunarmodules/busted.git /src

WORKDIR /src

RUN luarocks --tree /pkgdir/usr/local make \
    && find /pkgdir -type f -exec sed -i -e 's!/pkgdir!!g' {} \;

FROM akorn/luarocks:lua5.4-alpine AS final

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing dumb-init git

COPY --from=builder /pkgdir /

WORKDIR /data
