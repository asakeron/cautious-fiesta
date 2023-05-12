package = "cautious-fiesta"
version = "scm-0"
source = {
   url = "git+https://github.com/asakeron/cautious-fiesta.git";
}
description = {
   homepage = "https://github.com/asakeron/cautious-fiesta";
   license = "AGPL-3.0-or-later";
}
dependencies = {
   "lua >= 5.4, < 5.5";
}
build = {
   type = "builtin";
   modules = {
   };
}
