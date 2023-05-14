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
