FROM debian:bullseye AS builder

RUN apt update && \
    apt install --yes bash-completion sudo git build-essential m4 unzip wget

ENV LUA_V         5.4
ENV LUA_R         4

ENV LUA_VERSION   ${LUA_V}.${LUA_R}
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

COPY <<EOF /usr/local/etc/luarocks/config-${LUA_V}.lua
lua_interpreter = "lua";
variables = {
   LUA_DIR = "/usr/local";
   LUA_BINDIR = "/usr/local/bin";
}
EOF

FROM builder

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

RUN mkdir -p /usr/local/share/lua

# binaries
COPY --from=builder /usr/local/bin/luarocks       /usr/local/bin/luarocks
COPY --from=builder /usr/local/bin/luarocks-admin /usr/local/bin/luarocks-admin

# lua files
COPY --from=builder /usr/local/share/lua/    /usr/local/share/lua/
COPY --from=builder /usr/local/etc/luarocks/ /usr/local/etc/luarocks/

ARG USERNAME=vscode
ARG UID=1000
ARG GID=${UID}

RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd --uid ${UID} --gid ${GID} -m ${USERNAME} \
    && usermod --shell /bin/bash ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}

# Create the user luarocks tree and append it's scripts to PATH
RUN mkdir -p "${HOME}/.luarocks/bin"
RUN cp /usr/local/etc/luarocks/config-*.lua "$HOME/.luarocks/"
ENV PATH="${PATH}:${HOME}/.luarocks/bin"
