package tools.luaParser;

import hxparse.Lexer;
import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.Lexer;
import tools.luaParser.LuaDoc;
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
class ParserTest extends buddy.SingleSuite {
  // function compareTokens(a:TokenDef, b:TokenDef) {
  //   switch ([a, b]) {
  //     case [Comment(payloadA), Comment(payloadB)]:
  //       payloadA.should.be(payloadB);
  //     case [defaultA, defaultB]:
  //       defaultA.should.equal(defaultB);
  //   }
  // }
  public function new() {
    function compareTokens(a:TokenDef, b:TokenDef) {
      switch ([a, b]) {
        case [LuaDocParam(a), LuaDocParam(b)]:
          a.should.be(b);
        case [defaultA, defaultB]:
          defaultA.should.equal(defaultB);
      }
    }
    describe("Doc lexer", {
      it("should lex the param comments", {
        final suite:Map< String, Array< LuaDoc.DocToken > > = [
          "func fun()" => [
            DocToken.Identifier("func"),
            Identifier("fun"),
            Lparen,
            Rparen
          ],
          "str string" => [Identifier("str"), Identifier("string")],
          "from number" => [Identifier("from"), Identifier("number")],
          "to number" => [Identifier("to"), Identifier("number")],
          "opts? table<string, any>" => [
            Identifier("opts"),
            OptionalMod,
            Identifier("table"),
            TypeOpen,
            Identifier("string"),
            Identifier("any"),
            TypeClose,
          ],
        ];
        for (string => expected in suite) {
          final lexer = new LuaDocLexer(ByteData.ofString(string));
          final tokens = consumeTokens(lexer, LuaDocLexer.paramDoc);
          for (idx => token in tokens) {
            token.should.equal(expected[idx]);
          }
          // tokens.should.containExactly(expected);
        }
      });
    });

    describe("Lua Lexer", {
      it("should lex the basic function", {
        final lexer = new LuaLexer(readFixture("fixtures/basic_fn.lua"));
        final expected = [
          Comment("Invokes |vim-function| or |user-function| {func} with arguments {...}."),
          Comment("See also |vim.fn|."),
          Comment("Equivalent to:"),
          Comment("```lua"),
          Comment("vim.fn[func]({...})"),
          Comment("```"),
          LuaDocParam("func fun()"),
          Keyword(Function),
          Identifier("vim.call"),
          Rparen,
          Identifier("func"),
          ThreeDots,
          Lparen,
          Keyword(End),
          Newline
        ];

        final rawTokens = consumeTokens(lexer, LuaLexer.tok);
        final tokens = rawTokens.map(token -> token.tok);

        for (idx => token in tokens) {
          compareTokens(token, expected[idx]);
        }
      });

      it("should lex vim.iconv", {
        final lexer = new LuaLexer(readFixture("fixtures/vim_iconv.lua"));
        final rawTokens = consumeTokens(lexer, LuaLexer.tok);
        final tokens = rawTokens.map(token -> token.tok);
        final expected = [
          Comment("The result is a String, which is the text {str} converted from"),
          Comment("encoding {from} to encoding {to}. When the conversion fails `nil` is"),
          Comment("returned.  When some characters could not be converted they"),
          Comment('are replaced with "?".'),
          Comment("The encoding names are whatever the iconv() library function"),
          Comment('can accept, see ":Man 3 iconv".'),
          Comment("-- Parameters: ~"),
          Comment("• {str}   (string) Text to convert"),
          Comment("• {from}  (string) Encoding of {str}"),
          Comment("• {to}    (string) Target encoding"),
          Comment("-- Returns: ~"),
          Comment("Converted string if conversion succeeds, `nil` otherwise."),
          LuaDocParam("str string"),
          LuaDocParam("from number"),
          LuaDocParam("to number"),
          LuaDocParam("opts? table<string, any>"),
          Keyword(Function),
          Identifier("vim.iconv"),
          Rparen,
          Identifier("str"),
          Identifier("from"),
          Identifier("to"),
          Identifier("opts"),
          Lparen,
          Keyword(End),
          Newline
        ];
        for (idx => token in tokens) {
          compareTokens(token, expected[idx]);
        }
      });
      it("should lex filetype_getLInes", {
        final lexer = new LuaLexer(readFixture("fixtures/filetype_getLInes.lua"));
        final rawTokens = consumeTokens(lexer, LuaLexer.tok);
        final tokens = rawTokens.map(token -> token.tok);
        Log.print(tokens);
        final expected = [
          Comment("@private"),
          Comment("Get a single line or line range from the buffer."),
          Comment("If only start_lnum is specified, return a single line as a string."),
          Comment(
            "If both start_lnum and end_lnum are omitted, return all lines from the buffer."
          ),
          Comment("---@param bufnr number|nil The buffer to get the lines from"),
          LuaDocParam(
            "start_lnum number|nil The line number of the first line (inclusive, 1-based)"
          ),
          LuaDocParam("end_lnum number|nil The line number of the last line (inclusive, 1-based)"),
          LuaDocReturn("table<string>|string Array of lines, or string when end_lnum is omitted"),
          Keyword(Function),
          Identifier("M.getlines"),
          Rparen,
          Identifier("bufnr"),
          Identifier("start_lnum"),
          Identifier("end_lnum"),
          Lparen,
          Keyword(If),
          Identifier("end_lnum"),
          Keyword(Then),
          Comment("Return a line range"),
          Keyword(End),
          Keyword(If),
          Identifier("start_lnum"),
          Keyword(Then),
          Comment("Return a single line"),
          Keyword(Else),
          Comment("Return all lines"),
          Keyword(End),
          Keyword(End)
        ];

        for (idx => token in tokens) {
          compareTokens(token, expected[idx]);
        }
      });
    });
  }
}
