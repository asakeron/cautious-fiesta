FROM gcc:12-bullseye AS builder

ENV LUA_VERSION   5.4.4
ENV ROCKS_VERSION 3.9.2

RUN mkdir -p /build/lua
RUN mkdir -p /build/rocks

ADD https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz              /build/lua/
ADD https://luarocks.org/releases/luarocks-${ROCKS_VERSION}.tar.gz /build/rocks/

WORKDIR /build/lua
RUN tar -xzf lua-${LUA_VERSION}.tar.gz --strip-components=1
RUN make -j $(nproc) && \
    make local && \
    make install

WORKDIR /build/rocks
RUN tar -xzf luarocks-${ROCKS_VERSION}.tar.gz --strip-components=1
RUN ./configure --prefix=/usr/local && \
    make -j $(nproc) && \
    make install

FROM debian:bullseye

## lua

# binaries
COPY --from=builder /build/lua/install/bin/lua  /usr/local/bin/lua
COPY --from=builder /build/lua/install/bin/luac /usr/local/bin/luac

# libraries
COPY --from=builder /build/lua/install/lib/liblua.a /usr/local/lib/liblua.a

# include headers
COPY --from=builder /build/lua/install/include/lua.h     /usr/local/include/lua.h
COPY --from=builder /build/lua/install/include/luaconf.h /usr/local/include/luaconf.h
COPY --from=builder /build/lua/install/include/lualib.h  /usr/local/include/lualib.h
COPY --from=builder /build/lua/install/include/lauxlib.h /usr/local/include/lauxlib.h
COPY --from=builder /build/lua/install/include/lua.hpp   /usr/local/include/lua.hpp

# manual pages
COPY --from=builder /build/lua/install/man/man1/lua.1  /usr/local/man/man1/lua.1
COPY --from=builder /build/lua/install/man/man1/luac.1 /usr/local/man/man1/luac.1

## luarocks

RUN mkdir /etc/luarocks
RUN mkdir /usr/local/share/lua

# binaries
COPY --from=builder /usr/local/bin/luarocks       /usr/local/bin/luarocks
COPY --from=builder /usr/local/bin/luarocks-admin /usr/local/bin/luarocks-admin

# lua files
COPY --from=builder /usr/local/share/lua/         /usr/local/share/lua/

# configuration
COPY --from=builder /usr/local/etc/luarocks/      /usr/local/etc/luarocks/

RUN apt update && \
    apt install --yes bash-completion sudo git build-essential

ARG USERNAME=vscode
ARG UID=1000
ARG GID=${UID}

RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd --uid ${UID} --gid ${GID} -m ${USERNAME} \
    && usermod --shell /bin/bash ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
