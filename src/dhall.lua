--[[
    dhall.lua - A pure-lua implementation of a subset of Dhall.

    This grammar currently supports parsing of Dhall comments, which include
    block comments and line comments.

    Block comments:
        Block comments start with '{-' and end with '-}'. They can be nested.

    Line comments:
        Line comments start with '--' and continue to the end of the line.
]]
local lpeg = require("lpeg")

local grammar = {
    -- The starting rule of the grammar
    "S",
    S = lpeg.V("block_comment") + lpeg.V("line_comment"),

    -- Character classes
    -- TODO: Dhall fully supports UTF-8. This implementation currently only supports printable ASCII.
    printable_ascii = lpeg.R("\32\127"),
    tab = lpeg.P("\t"),
    end_of_line = lpeg.P("\n")
                + lpeg.P("\r\n"),

    -- Block comments
    block_comment_char = lpeg.V("printable_ascii")
                       + lpeg.V("tab")
                       + lpeg.V("end_of_line"),
    block_comment = lpeg.P("{-") * lpeg.V("block_comment_continue"),
    block_comment_continue = lpeg.P("-}")
                           + lpeg.V("block_comment") * lpeg.V("block_comment_continue")
                           + lpeg.V("block_comment_char") * lpeg.V("block_comment_continue"),

    -- Line comments
    not_end_of_line = lpeg.V("printable_ascii")
                    + lpeg.V("tab"),
    line_comment_prefix = lpeg.P("--") * (lpeg.V("not_end_of_line") ^ 0),
    line_comment = lpeg.V("line_comment_prefix") * lpeg.V("end_of_line")
}

return lpeg.P(grammar)
