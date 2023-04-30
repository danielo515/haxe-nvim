package tools.luaParser;

import hxparse.Lexer;
import haxe.io.Path;
import haxe.Json;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.Lexer.TokenDef;

using StringTools;
using buddy.Should;

function readFixture(path:String):ByteData {
  final file = File.read(Path.join([Sys.getCwd(), "tools", "luaParser", path]), false).readAll();
  return byte.ByteData.ofBytes(file);
}

function consumeTokens< T >(lexer:Lexer, tok):Array< T > {
  var tokens = [];
  try {
    var token = lexer.token(tok);
    while (token != null) {
      tokens.push(token);
      token = lexer.token(tok);
    }
    return tokens;
  }
  catch (e:Dynamic) {
    trace("Error parsing", e);
    trace("Dumping tokens:");
    return tokens;
  }
}

function dumpComments(tokens:Array< TokenDef >) {
  for (token in tokens) {
    switch (token) {
      case LuaDocParam(payload):
        Log.print('"$payload",');
      case _:
    }
  }
}

@colorize
class ParserTest extends buddy.BuddySuite {
  public function new() {
    describe("Lua Lexer", {
      it("should parse the basic function", {
        final parser = new LuaParser(readFixture("fixtures/basic_fn.lua"));
        final expectedDescription = [
          "Invokes |vim-function| or |user-function| {func} with arguments {...}.",
          "See also |vim.fn|.",
          "Equivalent to:",
          "```lua",
          "    vim.fn[func]({...})",
          "```",
        ].join('\n');
        final actual = parser.parse();
        switch (actual) {
          case FunctionWithDocs(def):
            def.name.should.be("call");
            def.args.should.containExactly(["func", "kwargs"]);
            def.namespace.should.containExactly(["vim"]);
            Json.stringify(def.typedArgs).should.be(Json.stringify([{
              name: "func",
              description: "",
              isOptional: false,
              type: "Function"
            }]));
            def.description.should.be(expectedDescription);
          case _: fail("Expected function with docs");
        }
      });

      it("should lex vim.iconv", {
        final parser = new LuaParser(readFixture("fixtures/vim_iconv.lua"));
        final expected = {
          name: "iconv",
          namespace: ["vim"],
          args: ["str", "from", "to", "opts"],
          typedArgs: [{
            name: "str",
            description: "",
            isOptional: false,
            type: "String"
          }, {
            name: "from",
            description: "",
            isOptional: false,
            type: "Number"
          }, {
            name: "to",
            description: "",
            isOptional: false,
            type: "Number"
          }, {
            name: "?opts",
            description: "",
            isOptional: true,
            type: "Table<String,Any>"
          }],
          description: [
            'The result is a String, which is the text {str} converted from',
            'encoding {from} to encoding {to}. When the conversion fails `nil` is',
            'returned.  When some characters could not be converted they',
            'are replaced with "?".',
            'The encoding names are whatever the iconv() library function',
            'can accept, see ":Man 3 iconv".',
            '-- Parameters: ~',
            '  • {str}   (string) Text to convert',
            '  • {from}  (string) Encoding of {str}',
            '  • {to}    (string) Target encoding',
            '-- Returns: ~',
            '    Converted string if conversion succeeds, `nil` otherwise.',
          ].join('\n'),
          isPrivate: false
        };
        final actual = parser.parse();
        switch (actual) {
          case FunctionWithDocs({
            name: name,
            namespace: namespace,
            args: args,
            typedArgs: typedArgs,
            description: description,
            isPrivate: isPrivate
          }):
            name.should.be(expected.name);
            namespace.should.containExactly(expected.namespace);
            args.should.containExactly(expected.args);
            Json.stringify(typedArgs).should.be(Json.stringify(expected.typedArgs));
            description.should.be(expected.description);
            isPrivate.should.be(expected.isPrivate);
          case _: fail("Expected function with docs");
        }
      });
      it("should lex filetype_getLInes", {
        final parser = new LuaParser(readFixture("fixtures/filetype_getLines.lua"));
        final expected = {
          name: "getlines",
          namespace: ["M"],
          args: ["bufnr", "start_lnum", "end_lnum"],
          typedArgs: [{
            name: "start_lnum",
            description: "The line number of the first line (inclusive, 1-based)",
            isOptional: false,
            type: "Either<Number, Nil>"
          }, {
            name: "end_lnum",
            description: "The line number of the last line (inclusive, 1-based)",
            isOptional: false,
            type: "Either<Number, Nil>"
          }],
          description: [
            'Get a single line or line range from the buffer.',
            'If only start_lnum is specified, return a single line as a string.',
            'If both start_lnum and end_lnum are omitted, return all lines from the buffer.',
            '---@param bufnr number|nil The buffer to get the lines from',
          ].join('\n'),
          isPrivate: true,
        };
        final actual = parser.parse();
        switch (actual) {
          case FunctionWithDocs({
            name: name,
            namespace: namespace,
            args: args,
            typedArgs: typedArgs,
            description: description,
            isPrivate: isPrivate,
            returnDoc: rt
          }):
            name.should.be(expected.name);
            namespace.should.containExactly(expected.namespace);
            args.should.containExactly(expected.args);
            Json.stringify(typedArgs).should.be(Json.stringify(expected.typedArgs));
            description.should.be(expected.description);
            isPrivate.should.be(expected.isPrivate);
            rt.description.should.be("Array of lines, or string when end_lnum is omitted");
            rt.type.should.be("Either<Table<String>, String>");
            rt.description.should.be("Array of lines, or string when end_lnum is omitted");
          case _: fail("Expected function with docs");
        }
      });
    });
  }
}
