describe("Dhall Parser", function()
    local parser = require("dhall")

    it("parses block comments", function()
        local simple = "{- a simple block comment -}"
        local nested = "{- a nested {- block comment -} -}"
        local block = "{- a block comment with a line break -}"
        local invalid = "{- an unfinished block comment"

        assert.are.equal(simple:len() + 1, parser:match(simple))
        assert.are.equal(nested:len() + 1, parser:match(nested))
        assert.are.equal(block:len() + 1, parser:match(block))
        assert.is_nil(parser:match(invalid))
    end)

    it("parses line comments", function()
        local simple = "-- a line comment\n"
        local nested = "-- a line comment with -- in it\n"
        local line_and_block = "-- a line comment followed by a block comment {- -}\n"

        assert.are.equal(simple:len() + 1, parser:match(simple))
        assert.are.equal(nested:len() + 1, parser:match(nested))
        assert.are.equal(line_and_block:len() + 1, parser:match(line_and_block))
    end)
end)

describe("Dhall Parser UTF-8 tests", function()
    local parser = require("dhall")

    it("parses UTF-8 characters", function()
        local utf8_in_line_comment = "-- a line comment with UTF-8: åäö\n"
        local utf8_in_block_comment = "{- a block comment with UTF-8: åäö -}"
        local utf8_in_nested_block_comment = "{- a nested block comment with UTF-8: åäö {- åäö -} åäö -}"

        assert.are.equal(utf8_in_line_comment:len() + 1, parser:match(utf8_in_line_comment))
        assert.are.equal(utf8_in_block_comment:len() + 1, parser:match(utf8_in_block_comment))
        assert.are.equal(utf8_in_nested_block_comment:len() + 1, parser:match(utf8_in_nested_block_comment))
    end)

    it("parses valid non-ASCII characters", function()
        local non_ascii_in_line_comment = "-- a line comment with non-ASCII: €\n"
        local non_ascii_in_block_comment = "{- a block comment with non-ASCII: € -}"
        local non_ascii_in_nested_block_comment = "{- a nested block comment with non-ASCII: € {- € -} € -}"

        assert.are.equal(non_ascii_in_line_comment:len() + 1, parser:match(non_ascii_in_line_comment))
        assert.are.equal(non_ascii_in_block_comment:len() + 1, parser:match(non_ascii_in_block_comment))
        assert.are.equal(non_ascii_in_nested_block_comment:len() + 1, parser:match(non_ascii_in_nested_block_comment))
    end)

    it("does not parse invalid UTF-8 sequences", function()
        -- This is an invalid UTF-8 sequence (in hexadecimal): C3 28
        local invalid_utf8 = "-- a line comment with invalid UTF-8: \195\40\n"

        assert.is_nil(parser:match(invalid_utf8))
    end)

    it("does not parse surrogate pairs", function()
        -- This is a surrogate pair (in hexadecimal): D800 DC00
        local surrogate_pair = "-- a line comment with a surrogate pair: \216\0\220\0\n"

        assert.is_nil(parser:match(surrogate_pair))
    end)

    it("does not parse non-characters", function()
        -- This is a non-character (in hexadecimal): FDD0
        local non_character = "-- a line comment with a non-character: \253\208\n"

        assert.is_nil(parser:match(non_character))
    end)
end)
