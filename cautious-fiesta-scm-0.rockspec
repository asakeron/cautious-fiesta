rockspec_format = "3.0"
package = "cautious-fiesta"
version = "scm-0"
source = {
   url = "git+https://github.com/asakeron/cautious-fiesta.git",
}
description = {
   homepage = "https://github.com/asakeron/cautious-fiesta",
   license = "AGPL-3.0-or-later",
}
dependencies = {
   "lua  >= 5.4, < 6",
   "lpeg >= 1.0, < 2",
}
build = {
   type = "builtin",
   modules = {
      dhall = "src/dhall.lua"
   },
}
test_dependencies = {
   "busted >= 2.1,  < 3",
   "luacov >= 0.15, < 1",
}
test = {
   type = "busted",
}
