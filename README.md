# cautious-fiesta

A pure-lua implementation of a subset of Dhall.

## Contributing

Before you start, please ensure that you have Lua and LuaRocks installed on your system.

In the root directory of this repository, set up a local LuaRocks tree and install the dependencies listed in the `.rockspec` file:

```bash
# Initialize a project-local LuaRocks tree.
luarocks init

# Install dependencies in the project-local LuaRocks tree.
luarocks install --deps-only cautious-fiesta-scm-0.rockspec

# Run tests
luarocks test
```

`luarocks init` also sets up wrapper scripts for `lua` and `luarocks`
executables that utilize the local LuaRocks tree.

### Further Information

- **[Lua](https://www.lua.org/)** - A powerful, efficient, lightweight, embeddable scripting language.
- **[LuaRocks](https://github.com/luarocks/luarocks/)** - The Package manager for the Lua programming language.

### Getting Help

If you encounter any issues or have questions about contributing to this project, please contact me through my GitHub profile.
