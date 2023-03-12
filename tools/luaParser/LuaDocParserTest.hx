package tools.luaParser;

import byte.ByteData;
import haxe.Json;
import tools.luaParser.LuaDoc;

using StringTools;
using buddy.Should;

@colorize
class LuaDocParserTest extends buddy.SingleSuite {
  public function new() {
    describe("vim/filetype.lua", {
      it(
        "---@param bufnr number|nil The buffer to get the lines from => bufnr: Either<Number, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("bufnr number|nil The buffer to get the lines from")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "bufnr",
            "description": "The buffer to get the lines from",
            "isOptional": false,
            "type": "Either<Number, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param start_lnum number|nil The line number of the first line (inclusive, 1-based) => start_lnum: Either<Number, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "start_lnum number|nil The line number of the first line (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "start_lnum",
            "description": "The line number of the first line (inclusive, 1-based)",
            "isOptional": false,
            "type": "Either<Number, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param end_lnum number|nil The line number of the last line (inclusive, 1-based) => end_lnum: Either<Number, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "end_lnum number|nil The line number of the last line (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "end_lnum",
            "description": "The line number of the last line (inclusive, 1-based)",
            "isOptional": false,
            "type": "Either<Number, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param s string The string to check => s: String", {
        final parser = new LuaDocParser(ByteData.ofString("s string The string to check"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "s",
          "description": "The string to check",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param patterns table<string> A list of Lua patterns => patterns: Table<String>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("patterns table<string> A list of Lua patterns")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "patterns",
            "description": "A list of Lua patterns",
            "isOptional": false,
            "type": "Table<String>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param bufnr number The buffer to get the line from => bufnr: Number", {
        final parser = new LuaDocParser(
          ByteData.ofString("bufnr number The buffer to get the line from")
        );
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "bufnr",
          "description": "The buffer to get the line from",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param start_lnum number The line number of the first line to start from (inclusive, 1-based) => start_lnum: Number",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "start_lnum number The line number of the first line to start from (inclusive, 1-based)"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "start_lnum",
            "description": "The line number of the first line to start from (inclusive, 1-based)",
            "isOptional": false,
            "type": "Number"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param filetypes table A table containing new filetype maps (see example). => filetypes: Table",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "filetypes table A table containing new filetype maps (see example)."
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "filetypes",
            "description": "A table containing new filetype maps (see example).",
            "isOptional": false,
            "type": "Table"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param args table Table specifying which matching strategy to use. Accepted keys are: => args: Table",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "args table Table specifying which matching strategy to use. Accepted keys are:"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "args",
            "description": "Table specifying which matching strategy to use. Accepted keys are:",
            "isOptional": false,
            "type": "Table"
          });
          Json.stringify(actual).should.be(expected);
        }
      );
    });
    describe("vim/fs.lua", {
      it("---@param start (string) Initial file or directory. => start: String", {
        final parser = new LuaDocParser(
          ByteData.ofString("start (string) Initial file or directory.")
        );
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "start",
          "description": "Initial file or directory.",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it("---@param file (string) File or directory => file: String", {
        final parser = new LuaDocParser(ByteData.ofString("file (string) File or directory"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "file",
          "description": "File or directory",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param path (string) An absolute or relative path to the directory to iterate => path: String",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "path (string) An absolute or relative path to the directory to iterate"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "path",
            "description": "An absolute or relative path to the directory to iterate",
            "isOptional": false,
            "type": "String"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param names (string|table|fun(name: string): boolean) Names of the files => names: Either<String, FunctionWithArgs(name: String):Boolean>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("names (string|table|fun(name: string): boolean) Names of the files")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "names",
            "description": "Names of the files",
            "isOptional": false,
            "type": "Either<String, FunctionWithArgs(name: String):Boolean>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param opts (table) Optional keyword arguments: => opts: Table", {
        final parser = new LuaDocParser(
          ByteData.ofString("opts (table) Optional keyword arguments:")
        );
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "opts",
          "description": "Optional keyword arguments:",
          "isOptional": false,
          "type": "Table"
        });
        Json.stringify(actual).should.be(expected);
      });

      it("---@param path (string) Path to normalize => path: String", {
        final parser = new LuaDocParser(ByteData.ofString("path (string) Path to normalize"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "path",
          "description": "Path to normalize",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });
    });
    describe("vim/keymap.lua", {
      it(
        "---@param mode string|table    Same mode short names as |nvim_set_keymap()|. => mode: Either<String, Table>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("mode string|table    Same mode short names as |nvim_set_keymap()|.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "mode",
            "description": "Same mode short names as |nvim_set_keymap()|.",
            "isOptional": false,
            "type": "Either<String, Table>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param lhs string           Left-hand side |{lhs}| of the mapping. => lhs: String",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("lhs string           Left-hand side |{lhs}| of the mapping.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "lhs",
            "description": "Left-hand side |{lhs}| of the mapping.",
            "isOptional": false,
            "type": "String"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param rhs string|function  Right-hand side |{rhs}| of the mapping. Can also be a Lua function. => rhs: Either<String, TFunction>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "rhs string|function  Right-hand side |{rhs}| of the mapping. Can also be a Lua function."
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "rhs",
            "description": "Right-hand side |{rhs}| of the mapping. Can also be a Lua function.",
            "isOptional": false,
            "type": "Either<String, TFunction>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param opts table|nil A table of |:map-arguments|. => opts: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("opts table|nil A table of |:map-arguments|.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "opts",
            "description": "A table of |:map-arguments|.",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param opts table|nil A table of optional arguments: => opts: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("opts table|nil A table of optional arguments:")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "opts",
            "description": "A table of optional arguments:",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );
    });
    describe("vim/lsp/buf.lua", {
      it("---@param method (string) LSP method name => method: String", {
        final parser = new LuaDocParser(ByteData.ofString("method (string) LSP method name"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "method",
          "description": "LSP method name",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param params (table|nil) Parameters to send to the server => params: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("params (table|nil) Parameters to send to the server")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "params",
            "description": "Parameters to send to the server",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param handler (function|nil) See |lsp-handler|. Follows |lsp-handler-resolution| => handler: Either<Function, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "handler (function|nil) See |lsp-handler|. Follows |lsp-handler-resolution|"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "handler",
            "description": "See |lsp-handler|. Follows |lsp-handler-resolution|",
            "isOptional": false,
            "type": "Either<Function, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param options table|nil additional options => options: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("options table|nil additional options")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "additional options",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "--- @param options table|nil Optional table which holds the following optional fields: => options: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "options table|nil Optional table which holds the following optional fields:"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "Optional table which holds the following optional fields:",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param options (table|nil) Can be used to specify FormattingOptions. => options: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("options (table|nil) Can be used to specify FormattingOptions.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "Can be used to specify FormattingOptions.",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param options table|nil with valid `FormattingOptions` entries => options: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("options table|nil with valid `FormattingOptions` entries")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "with valid `FormattingOptions` entries",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param timeout_ms (number) Request timeout => timeout_ms: Number", {
        final parser = new LuaDocParser(ByteData.ofString("timeout_ms (number) Request timeout"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "timeout_ms",
          "description": "Request timeout",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param options (table|nil) `FormattingOptions` entries => options: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("options (table|nil) `FormattingOptions` entries")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "`FormattingOptions` entries",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param timeout_ms (number|nil) Request timeout => timeout_ms: Either<Number, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("timeout_ms (number|nil) Request timeout")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "timeout_ms",
            "description": "Request timeout",
            "isOptional": false,
            "type": "Either<Number, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param order (table|nil) List of client names. Formatting is requested from clients => order: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "order (table|nil) List of client names. Formatting is requested from clients"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "order",
            "description": "List of client names. Formatting is requested from clients",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param options Table with valid `FormattingOptions` entries. => options: TIdentifier(Table)",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("options Table with valid `FormattingOptions` entries.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "options",
            "description": "with valid `FormattingOptions` entries.",
            "isOptional": false,
            "type": "TIdentifier(Table)"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param start_pos ({number, number}, optional) mark-indexed position. => start_pos: ?Vector2<Number,Number>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("start_pos ({number, number}, optional) mark-indexed position.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "start_pos",
            "description": ") mark-indexed position.",
            "isOptional": false,
            "type": "?Vector2<Number,Number>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param end_pos ({number, number}, optional) mark-indexed position. => end_pos: ?Vector2<Number,Number>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("end_pos ({number, number}, optional) mark-indexed position.")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "end_pos",
            "description": ") mark-indexed position.",
            "isOptional": false,
            "type": "?Vector2<Number,Number>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param new_name string|nil If not provided, the user will be prompted for a new => new_name: Either<String, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString(
              "new_name string|nil If not provided, the user will be prompted for a new"
            )
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "new_name",
            "description": "If not provided, the user will be prompted for a new",
            "isOptional": false,
            "type": "Either<String, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it("---@param context (table) Context for the request => context: Table", {
        final parser = new LuaDocParser(
          ByteData.ofString("context (table) Context for the request")
        );
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "context",
          "description": "Context for the request",
          "isOptional": false,
          "type": "Table"
        });
        Json.stringify(actual).should.be(expected);
      });

      it("---@param query (string, optional) => query: ?String", {
        final parser = new LuaDocParser(ByteData.ofString("query (string, optional)"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "query",
          "description": "",
          "isOptional": false,
          "type": "?String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(
        "---@param context table|nil `CodeActionContext` of the LSP specification: => context: Either<Table, Nil>",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("context table|nil `CodeActionContext` of the LSP specification:")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "context",
            "description": "`CodeActionContext` of the LSP specification:",
            "isOptional": false,
            "type": "Either<Table, Nil>"
          });
          Json.stringify(actual).should.be(expected);
        }
      );

      it(
        "---@param command_params table A valid `ExecuteCommandParams` object => command_params: Table",
        {
          final parser = new LuaDocParser(
            ByteData.ofString("command_params table A valid `ExecuteCommandParams` object")
          );
          final actual = parser.parse();
          final expected = Json.stringify({
            "name": "command_params",
            "description": "A valid `ExecuteCommandParams` object",
            "isOptional": false,
            "type": "Table"
          });
          Json.stringify(actual).should.be(expected);
        }
      );
    });
    describe("fn.json", {
      it(" @param lnum number => lnum: Number", {
        final parser = new LuaDocParser(ByteData.ofString("lnum number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "lnum",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param text string => text: String", {
        final parser = new LuaDocParser(ByteData.ofString("text string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "text",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param buf buffer => buf: BufferId", {
        final parser = new LuaDocParser(ByteData.ofString("buf buffer"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "buf",
          "description": "",
          "isOptional": false,
          "type": "BufferId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param winid? window => ?winid: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("winid? window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?winid",
          "description": "",
          "isOptional": true,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param winnr? window => ?winnr: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("winnr? window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?winnr",
          "description": "",
          "isOptional": true,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param tabnr? number => ?tabnr: Number", {
        final parser = new LuaDocParser(ByteData.ofString("tabnr? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?tabnr",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param nr? number => ?nr: Number", {
        final parser = new LuaDocParser(ByteData.ofString("nr? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?nr",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param msg? any => ?msg: Any", {
        final parser = new LuaDocParser(ByteData.ofString("msg? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?msg",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param error? any => ?error: Any", {
        final parser = new LuaDocParser(ByteData.ofString("error? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?error",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param buf? buffer => ?buf: BufferId", {
        final parser = new LuaDocParser(ByteData.ofString("buf? buffer"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?buf",
          "description": "",
          "isOptional": true,
          "type": "BufferId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param create? any => ?create: Any", {
        final parser = new LuaDocParser(ByteData.ofString("create? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?create",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param nr number => nr: Number", {
        final parser = new LuaDocParser(ByteData.ofString("nr number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "nr",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param func fun() => func: Function", {
        final parser = new LuaDocParser(ByteData.ofString("func fun()"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "func",
          "description": "",
          "isOptional": false,
          "type": "Function"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dict? table<string, any> => ?dict: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("dict? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?dict",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param stream? any => ?stream: Any", {
        final parser = new LuaDocParser(ByteData.ofString("stream? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?stream",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param string string => string: String", {
        final parser = new LuaDocParser(ByteData.ofString("string string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "string",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param utf8? any => ?utf8: Any", {
        final parser = new LuaDocParser(ByteData.ofString("utf8? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?utf8",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param countcc? any => ?countcc: Any", {
        final parser = new LuaDocParser(ByteData.ofString("countcc? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?countcc",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param win? window => ?win: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("win? window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?win",
          "description": "",
          "isOptional": true,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param what? any => ?what: Any", {
        final parser = new LuaDocParser(ByteData.ofString("what? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?what",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param choices? any => ?choices: Any", {
        final parser = new LuaDocParser(ByteData.ofString("choices? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?choices",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param default? any => ?default: Any", {
        final parser = new LuaDocParser(ByteData.ofString("default? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?default",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param type? any => ?type: Any", {
        final parser = new LuaDocParser(ByteData.ofString("type? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?type",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param ic? any => ?ic: Any", {
        final parser = new LuaDocParser(ByteData.ofString("ic? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?ic",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param start? number => ?start: Number", {
        final parser = new LuaDocParser(ByteData.ofString("start? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?start",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param num? any => ?num: Any", {
        final parser = new LuaDocParser(ByteData.ofString("num? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?num",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dbpath? any => ?dbpath: Any", {
        final parser = new LuaDocParser(ByteData.ofString("dbpath? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?dbpath",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param prepend? any => ?prepend: Any", {
        final parser = new LuaDocParser(ByteData.ofString("prepend? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?prepend",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param index? number => ?index: Number", {
        final parser = new LuaDocParser(ByteData.ofString("index? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?index",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param types? any => ?types: Any", {
        final parser = new LuaDocParser(ByteData.ofString("types? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?types",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param list any[] => list: Array<Any>", {
        final parser = new LuaDocParser(ByteData.ofString("list any[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "list",
          "description": "",
          "isOptional": false,
          "type": "Array<Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param noref? any => ?noref: Any", {
        final parser = new LuaDocParser(ByteData.ofString("noref? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?noref",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param flags? any => ?flags: Any", {
        final parser = new LuaDocParser(ByteData.ofString("flags? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?flags",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param last? any => ?last: Any", {
        final parser = new LuaDocParser(ByteData.ofString("last? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?last",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dict table<string, any> => dict: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("dict table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "dict",
          "description": "",
          "isOptional": false,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param callback fun() => callback: Function", {
        final parser = new LuaDocParser(ByteData.ofString("callback fun()"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "callback",
          "description": "",
          "isOptional": false,
          "type": "Function"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param col number => col: Number", {
        final parser = new LuaDocParser(ByteData.ofString("col number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "col",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param listall? any => ?listall: Any", {
        final parser = new LuaDocParser(ByteData.ofString("listall? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?listall",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param silent? any => ?silent: Any", {
        final parser = new LuaDocParser(ByteData.ofString("silent? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?silent",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param nosuf? boolean => ?nosuf: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("nosuf? boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?nosuf",
          "description": "",
          "isOptional": true,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param expr3? any => ?expr3: Any", {
        final parser = new LuaDocParser(ByteData.ofString("expr3? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?expr3",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param mode? any => ?mode: Any", {
        final parser = new LuaDocParser(ByteData.ofString("mode? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?mode",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param path? any => ?path: Any", {
        final parser = new LuaDocParser(ByteData.ofString("path? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?path",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param count? any => ?count: Any", {
        final parser = new LuaDocParser(ByteData.ofString("count? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?count",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param maxdepth? any => ?maxdepth: Any", {
        final parser = new LuaDocParser(ByteData.ofString("maxdepth? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?maxdepth",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param arglist? any => ?arglist: Any", {
        final parser = new LuaDocParser(ByteData.ofString("arglist? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?arglist",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param atexit? any => ?atexit: Any", {
        final parser = new LuaDocParser(ByteData.ofString("atexit? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?atexit",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param end_? number => ?end_: Number", {
        final parser = new LuaDocParser(ByteData.ofString("end_? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?end_",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param def? any => ?def: Any", {
        final parser = new LuaDocParser(ByteData.ofString("def? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?def",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param expr? any => ?expr: Any", {
        final parser = new LuaDocParser(ByteData.ofString("expr? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?expr",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param filtered? any => ?filtered: Any", {
        final parser = new LuaDocParser(ByteData.ofString("filtered? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?filtered",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param name? any => ?name: Any", {
        final parser = new LuaDocParser(ByteData.ofString("name? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?name",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param regname? any => ?regname: Any", {
        final parser = new LuaDocParser(ByteData.ofString("regname? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?regname",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param p1? any => ?p1: Any", {
        final parser = new LuaDocParser(ByteData.ofString("p1? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?p1",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param list? any[] => ?list: Array<Any>", {
        final parser = new LuaDocParser(ByteData.ofString("list? any[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?list",
          "description": "",
          "isOptional": true,
          "type": "Array<Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param tabnr number => tabnr: Number", {
        final parser = new LuaDocParser(ByteData.ofString("tabnr number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "tabnr",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param winnr window => winnr: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("winnr window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "winnr",
          "description": "",
          "isOptional": false,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param timeout? any => ?timeout: Any", {
        final parser = new LuaDocParser(ByteData.ofString("timeout? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?timeout",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param expr string => expr: String", {
        final parser = new LuaDocParser(ByteData.ofString("expr string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "expr",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param nosuf? any => ?nosuf: Any", {
        final parser = new LuaDocParser(ByteData.ofString("nosuf? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?nosuf",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param allinks? any => ?allinks: Any", {
        final parser = new LuaDocParser(ByteData.ofString("allinks? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?allinks",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param abbr? any => ?abbr: Any", {
        final parser = new LuaDocParser(ByteData.ofString("abbr? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?abbr",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param item? any => ?item: Any", {
        final parser = new LuaDocParser(ByteData.ofString("item? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?item",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param from number => from: Number", {
        final parser = new LuaDocParser(ByteData.ofString("from number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "from",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param to number => to: Number", {
        final parser = new LuaDocParser(ByteData.ofString("to number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "to",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param opts table<string, any> => opts: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("opts table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "opts",
          "description": "",
          "isOptional": false,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param text? string => ?text: String", {
        final parser = new LuaDocParser(ByteData.ofString("text? string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?text",
          "description": "",
          "isOptional": true,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param idx? any => ?idx: Any", {
        final parser = new LuaDocParser(ByteData.ofString("idx? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?idx",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param opts? table<string, any> => ?opts: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("opts? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?opts",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param sep? any => ?sep: Any", {
        final parser = new LuaDocParser(ByteData.ofString("sep? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?sep",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param expr1? any => ?expr1: Any", {
        final parser = new LuaDocParser(ByteData.ofString("expr1? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?expr1",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param priority? any => ?priority: Any", {
        final parser = new LuaDocParser(ByteData.ofString("priority? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?priority",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param id? any => ?id: Any", {
        final parser = new LuaDocParser(ByteData.ofString("id? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?id",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param pos number => pos: Number", {
        final parser = new LuaDocParser(ByteData.ofString("pos number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "pos",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param str string => str: String", {
        final parser = new LuaDocParser(ByteData.ofString("str string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "str",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param modes? any => ?modes: Any", {
        final parser = new LuaDocParser(ByteData.ofString("modes? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?modes",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param prot? any => ?prot: Any", {
        final parser = new LuaDocParser(ByteData.ofString("prot? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?prot",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param len? any => ?len: Any", {
        final parser = new LuaDocParser(ByteData.ofString("len? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?len",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param max? any => ?max: Any", {
        final parser = new LuaDocParser(ByteData.ofString("max? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?max",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param stride? any => ?stride: Any", {
        final parser = new LuaDocParser(ByteData.ofString("stride? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?stride",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param initial? any => ?initial: Any", {
        final parser = new LuaDocParser(ByteData.ofString("initial? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?initial",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param args? any[] => ?args: Array<Any>", {
        final parser = new LuaDocParser(ByteData.ofString("args? any[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?args",
          "description": "",
          "isOptional": true,
          "type": "Array<Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param ...? any => ?kwargs: Any", {
        final parser = new LuaDocParser(ByteData.ofString("...? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?kwargs",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param argv? any => ?argv: Any", {
        final parser = new LuaDocParser(ByteData.ofString("argv? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?argv",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param winid window => winid: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("winid window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "winid",
          "description": "",
          "isOptional": false,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param stopline? any => ?stopline: Any", {
        final parser = new LuaDocParser(ByteData.ofString("stopline? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?stopline",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param skip? any => ?skip: Any", {
        final parser = new LuaDocParser(ByteData.ofString("skip? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?skip",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param options? table<string, any> => ?options: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("options? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?options",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param global? any => ?global: Any", {
        final parser = new LuaDocParser(ByteData.ofString("global? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?global",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param thisblock? any => ?thisblock: Any", {
        final parser = new LuaDocParser(ByteData.ofString("thisblock? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?thisblock",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param start number => start: Number", {
        final parser = new LuaDocParser(ByteData.ofString("start number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "start",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param end_ number => end_: Number", {
        final parser = new LuaDocParser(ByteData.ofString("end_ number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "end_",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param address? any => ?address: Any", {
        final parser = new LuaDocParser(ByteData.ofString("address? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?address",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param pos? number => ?pos: Number", {
        final parser = new LuaDocParser(ByteData.ofString("pos? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?pos",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param action? any => ?action: Any", {
        final parser = new LuaDocParser(ByteData.ofString("action? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?action",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param special? any => ?special: Any", {
        final parser = new LuaDocParser(ByteData.ofString("special? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?special",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param col? number => ?col: Number", {
        final parser = new LuaDocParser(ByteData.ofString("col? number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?col",
          "description": "",
          "isOptional": true,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param func? fun() => ?func: Function", {
        final parser = new LuaDocParser(ByteData.ofString("func? fun()"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?func",
          "description": "",
          "isOptional": true,
          "type": "Function"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param sentence? any => ?sentence: Any", {
        final parser = new LuaDocParser(ByteData.ofString("sentence? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?sentence",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param capital? any => ?capital: Any", {
        final parser = new LuaDocParser(ByteData.ofString("capital? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?capital",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param pattern? any => ?pattern: Any", {
        final parser = new LuaDocParser(ByteData.ofString("pattern? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?pattern",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param keepempty? any => ?keepempty: Any", {
        final parser = new LuaDocParser(ByteData.ofString("keepempty? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?keepempty",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param quoted? any => ?quoted: Any", {
        final parser = new LuaDocParser(ByteData.ofString("quoted? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?quoted",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param base? any => ?base: Any", {
        final parser = new LuaDocParser(ByteData.ofString("base? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?base",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param skipcc? any => ?skipcc: Any", {
        final parser = new LuaDocParser(ByteData.ofString("skipcc? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?skipcc",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param time? any => ?time: Any", {
        final parser = new LuaDocParser(ByteData.ofString("time? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?time",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param index number => index: Number", {
        final parser = new LuaDocParser(ByteData.ofString("index number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "index",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param chars? any => ?chars: Any", {
        final parser = new LuaDocParser(ByteData.ofString("chars? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?chars",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param input? any => ?input: Any", {
        final parser = new LuaDocParser(ByteData.ofString("input? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?input",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param arg? any => ?arg: Any", {
        final parser = new LuaDocParser(ByteData.ofString("arg? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?arg",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param filename? any => ?filename: Any", {
        final parser = new LuaDocParser(ByteData.ofString("filename? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?filename",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param mask? any => ?mask: Any", {
        final parser = new LuaDocParser(ByteData.ofString("mask? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?mask",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dir? any => ?dir: Any", {
        final parser = new LuaDocParser(ByteData.ofString("dir? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?dir",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param interval? any => ?interval: Any", {
        final parser = new LuaDocParser(ByteData.ofString("interval? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?interval",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param bufnr buffer => bufnr: BufferId", {
        final parser = new LuaDocParser(ByteData.ofString("bufnr buffer"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "bufnr",
          "description": "",
          "isOptional": false,
          "type": "BufferId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param tab? any => ?tab: Any", {
        final parser = new LuaDocParser(ByteData.ofString("tab? any"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?tab",
          "description": "",
          "isOptional": true,
          "type": "Any"
        });
        Json.stringify(actual).should.be(expected);
      });
    });
    describe("api.json", {
      it(" @param buffer buffer => buffer: BufferId", {
        final parser = new LuaDocParser(ByteData.ofString("buffer buffer"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "buffer",
          "description": "",
          "isOptional": false,
          "type": "BufferId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param ns_id number => ns_id: Number", {
        final parser = new LuaDocParser(ByteData.ofString("ns_id number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "ns_id",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param hl_group string => hl_group: String", {
        final parser = new LuaDocParser(ByteData.ofString("hl_group string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "hl_group",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param line number => line: Number", {
        final parser = new LuaDocParser(ByteData.ofString("line number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "line",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param col_start number => col_start: Number", {
        final parser = new LuaDocParser(ByteData.ofString("col_start number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "col_start",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param col_end number => col_end: Number", {
        final parser = new LuaDocParser(ByteData.ofString("col_end number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "col_end",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param send_buffer boolean => send_buffer: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("send_buffer boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "send_buffer",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param fun fun() => fun: Function", {
        final parser = new LuaDocParser(ByteData.ofString("fun fun()"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "fun",
          "description": "",
          "isOptional": false,
          "type": "Function"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param line_start number => line_start: Number", {
        final parser = new LuaDocParser(ByteData.ofString("line_start number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "line_start",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param line_end number => line_end: Number", {
        final parser = new LuaDocParser(ByteData.ofString("line_end number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "line_end",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param name string => name: String", {
        final parser = new LuaDocParser(ByteData.ofString("name string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "name",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param command object => command: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("command object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "command",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param id number => id: Number", {
        final parser = new LuaDocParser(ByteData.ofString("id number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "id",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param mode string => mode: String", {
        final parser = new LuaDocParser(ByteData.ofString("mode string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "mode",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param lhs string => lhs: String", {
        final parser = new LuaDocParser(ByteData.ofString("lhs string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "lhs",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param start object => start: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("start object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "start",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param end_ object => end_: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("end_ object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "end_",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param strict_indexing boolean => strict_indexing: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("strict_indexing boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "strict_indexing",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param start_row number => start_row: Number", {
        final parser = new LuaDocParser(ByteData.ofString("start_row number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "start_row",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param start_col number => start_col: Number", {
        final parser = new LuaDocParser(ByteData.ofString("start_col number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "start_col",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param end_row number => end_row: Number", {
        final parser = new LuaDocParser(ByteData.ofString("end_row number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "end_row",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param end_col number => end_col: Number", {
        final parser = new LuaDocParser(ByteData.ofString("end_col number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "end_col",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param rhs string => rhs: String", {
        final parser = new LuaDocParser(ByteData.ofString("rhs string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "rhs",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param replacement string[] => replacement: Array<String>", {
        final parser = new LuaDocParser(ByteData.ofString("replacement string[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "replacement",
          "description": "",
          "isOptional": false,
          "type": "Array<String>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param value object => value: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("value object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "value",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dict object => dict: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("dict object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "dict",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param fn string => fn: String", {
        final parser = new LuaDocParser(ByteData.ofString("fn string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "fn",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param args any[] => args: Array<Any>", {
        final parser = new LuaDocParser(ByteData.ofString("args any[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "args",
          "description": "",
          "isOptional": false,
          "type": "Array<Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param chan number => chan: Number", {
        final parser = new LuaDocParser(ByteData.ofString("chan number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "chan",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param data string => data: String", {
        final parser = new LuaDocParser(ByteData.ofString("data string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "data",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param cmd? table<string, any> => ?cmd: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("cmd? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?cmd",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param command string => command: String", {
        final parser = new LuaDocParser(ByteData.ofString("command string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "command",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param event object => event: Dynamic", {
        final parser = new LuaDocParser(ByteData.ofString("event object"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "event",
          "description": "",
          "isOptional": false,
          "type": "Dynamic"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param listed boolean => listed: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("listed boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "listed",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param scratch boolean => scratch: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("scratch boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "scratch",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param chunks any[] => chunks: Array<Any>", {
        final parser = new LuaDocParser(ByteData.ofString("chunks any[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "chunks",
          "description": "",
          "isOptional": false,
          "type": "Array<Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param history boolean => history: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("history boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "history",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param src string => src: String", {
        final parser = new LuaDocParser(ByteData.ofString("src string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "src",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param output boolean => output: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("output boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "output",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param keys string => keys: String", {
        final parser = new LuaDocParser(ByteData.ofString("keys string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "keys",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param escape_ks boolean => escape_ks: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("escape_ks boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "escape_ks",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param hl_id number => hl_id: Number", {
        final parser = new LuaDocParser(ByteData.ofString("hl_id number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "hl_id",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param rgb boolean => rgb: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("rgb boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "rgb",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param pid number => pid: Number", {
        final parser = new LuaDocParser(ByteData.ofString("pid number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "pid",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param all boolean => all: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("all boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "all",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param button string => button: String", {
        final parser = new LuaDocParser(ByteData.ofString("button string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "button",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param action string => action: String", {
        final parser = new LuaDocParser(ByteData.ofString("action string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "action",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param modifier string => modifier: String", {
        final parser = new LuaDocParser(ByteData.ofString("modifier string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "modifier",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param grid number => grid: Number", {
        final parser = new LuaDocParser(ByteData.ofString("grid number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "grid",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param row number => row: Number", {
        final parser = new LuaDocParser(ByteData.ofString("row number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "row",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param msg string => msg: String", {
        final parser = new LuaDocParser(ByteData.ofString("msg string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "msg",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param log_level number => log_level: Number", {
        final parser = new LuaDocParser(ByteData.ofString("log_level number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "log_level",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param enter boolean => enter: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("enter boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "enter",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param config? table<string, any> => ?config: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("config? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?config",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param flags string => flags: String", {
        final parser = new LuaDocParser(ByteData.ofString("flags string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "flags",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param highlight boolean => highlight: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("highlight boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "highlight",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param crlf boolean => crlf: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("crlf boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "crlf",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param phase number => phase: Number", {
        final parser = new LuaDocParser(ByteData.ofString("phase number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "phase",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param lines string[] => lines: Array<String>", {
        final parser = new LuaDocParser(ByteData.ofString("lines string[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "lines",
          "description": "",
          "isOptional": false,
          "type": "Array<String>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param type string => type: String", {
        final parser = new LuaDocParser(ByteData.ofString("type string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "type",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param after boolean => after: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("after boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "after",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param follow boolean => follow: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("follow boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "follow",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param from_part boolean => from_part: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("from_part boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "from_part",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param do_lt boolean => do_lt: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("do_lt boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "do_lt",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param special boolean => special: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("special boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "special",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param item number => item: Number", {
        final parser = new LuaDocParser(ByteData.ofString("item number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "item",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param insert boolean => insert: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("insert boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "insert",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param finish boolean => finish: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("finish boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "finish",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param dir string => dir: String", {
        final parser = new LuaDocParser(ByteData.ofString("dir string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "dir",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param line string => line: String", {
        final parser = new LuaDocParser(ByteData.ofString("line string"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "line",
          "description": "",
          "isOptional": false,
          "type": "String"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param tabpage tabpage => tabpage: TIdentifier(tabpage)", {
        final parser = new LuaDocParser(ByteData.ofString("tabpage tabpage"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "tabpage",
          "description": "",
          "isOptional": false,
          "type": "TIdentifier(tabpage)"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param window window => window: WindowId", {
        final parser = new LuaDocParser(ByteData.ofString("window window"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "window",
          "description": "",
          "isOptional": false,
          "type": "WindowId"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param val? table<string, any> => ?val: Table<String,Any>", {
        final parser = new LuaDocParser(ByteData.ofString("val? table<string, any>"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "?val",
          "description": "",
          "isOptional": true,
          "type": "Table<String,Any>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param force boolean => force: Boolean", {
        final parser = new LuaDocParser(ByteData.ofString("force boolean"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "force",
          "description": "",
          "isOptional": false,
          "type": "Boolean"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param pos number[] => pos: Array<Number>", {
        final parser = new LuaDocParser(ByteData.ofString("pos number[]"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "pos",
          "description": "",
          "isOptional": false,
          "type": "Array<Number>"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param height number => height: Number", {
        final parser = new LuaDocParser(ByteData.ofString("height number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "height",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });

      it(" @param width number => width: Number", {
        final parser = new LuaDocParser(ByteData.ofString("width number"));
        final actual = parser.parse();
        final expected = Json.stringify({
          "name": "width",
          "description": "",
          "isOptional": false,
          "type": "Number"
        });
        Json.stringify(actual).should.be(expected);
      });
    });
  }
}
