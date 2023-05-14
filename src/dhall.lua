-- dhall.lua - A pure-lua implementation of a subset of Dhall.
local lpeg = require("lpeg")

local grammar = {
    -- The starting rule of the grammar
    "S",
    S = lpeg.V("block_comment") + lpeg.V("line_comment"),

    -- continuation byte for multi-byte UTF-8 sequences
    cont = lpeg.R("\128\191"),

    -- UTF-8 decoding patterns
    utf8 = lpeg.R("\194\223") * lpeg.V("cont")
         + lpeg.R("\224\239") * lpeg.V("cont") ^ 2
         + lpeg.R("\240\244") * lpeg.V("cont") ^ 3,

    printable_ascii = lpeg.R("\32\127"),

    -- NOTE: There are many line endings in the wild
    --
    -- See: https://en.wikipedia.org/wiki/Newline
    --
    -- For simplicity this supports Unix and Windows line-endings, which are the most
    -- common
    end_of_line = lpeg.P("\n")
                + lpeg.P("\r\n"),

    -- This rule matches all characters that are not:
    --
    -- * not ASCII
    -- * not part of a surrogate pair
    -- * not a "non-character"
    valid_non_ascii = lpeg.V("utf8"),

    tab = lpeg.P("\t"),

    block_comment_char = lpeg.V("printable_ascii")
                       + lpeg.V("valid_non_ascii")
                       + lpeg.V("tab")
                       + lpeg.V("end_of_line"),

    block_comment = lpeg.P("{-") * lpeg.V("block_comment_continue"),

    block_comment_continue = lpeg.P("-}")
                           + lpeg.V("block_comment") * lpeg.V("block_comment_continue")
                           + lpeg.V("block_comment_char") * lpeg.V("block_comment_continue"),

    not_end_of_line = lpeg.V("printable_ascii")
                    + lpeg.V("valid_non_ascii")
                    + lpeg.V("tab"),

    line_comment_prefix = lpeg.P("--") * (lpeg.V("not_end_of_line") ^ 0),

    line_comment = lpeg.V("line_comment_prefix") * lpeg.V("end_of_line"),

    whitespace_chunk = lpeg.P(" ")
                     + lpeg.V("tab")
                     + lpeg.V("end_of_line")
                     + lpeg.V("line_comment")
                     + lpeg.V("block_comment"),

    whsp = lpeg.V("whitespace_chunk") ^ 0,

    whsp1 = lpeg.V("whitespace_chunk") ^ 1
}

return lpeg.P(grammar)
