package tools;

import tools.Log;
import byte.ByteData;
import tools.luaParser.LuaParser;
import haxe.Json;
import tools.Result;
import tools.GitRepo;
import tools.Cmd;
import haxe.io.Path;
import sys.io.Process;
import sys.io.File;

using Lambda;
using StringTools;
using sys.FileSystem;

typedef ApiData = {
  final functions:Array< {name:String, return_type:String, deprecated_since:Null< Int >} >;
}

function capitalize(value:String):String {
  return value.charAt(0).toUpperCase() + value.substr(1);
}

function prettyPrint(?msg, data:Dynamic) {
  Sys.println(msg);
  Sys.println(Json.stringify(data, null, "  "));
}

typedef FunctionBlock = {
  final docs:Array< String >;
  var parameters:Array< Array< String > >;
  var return_type:String;
  final annotations:Array< String >;
  var name:String;
  var fullyQualified_name:String;
}

enum Annotation {
  Return(type:String);
  Param(name:String, type:String);
  Optional(name:String, type:String);
}

typedef AnnotationMap = Map< String, Annotation >;

@:tink class AnnotationParser {
  final getPath:String -> String;

  public function new(getPath) {
    this.getPath = getPath;
  }

  function getFunctionBlocks(file) {
    final path = getPath(file);
    trace('Parsing $path');
    final file = File.read(path, false).readAll().toString();
    return file.split("\n\n").filter(x -> x != "" && x != "---@meta").map(x -> x.split("\n"));
  }

  static function formatTypeStr(type:String):String {
    return switch (type) {
      case '$kind[]':
        'lua.Table<Int,${formatTypeStr(kind)}>';
      case 'any': 'Dynamic';
      case 'number' | 'Number': 'Int';
      case 'table' | 'List': 'lua.Table<Int, Dynamic>';
      case 'table<string, any>' | 'object': 'lua.Table<String, Dynamic>';
      case 'table<string, $b>': 'lua.Table<String, ${formatTypeStr(b)}>';
      case 'fun()': 'Function';
      case 'boolean': 'Bool';
      case '$type|nil': 'Null<${formatTypeStr(type)}>';
      case ~/[a-z][|][a-z]/i: 'Dynamic';
      case value: capitalize(value);
    }
  }

  static function parseAnnotations(annotations:Array< String >):AnnotationMap {
    var result = new Map();

    return annotations.fold((annotation, parsed:AnnotationMap) -> {
      final returnRegex = ~/@return (.*)/i;
      final returnWithParens = ~/@return \(([^\)]*)\)(.*)/i;
      final paramSimple = ~/@param (\w*) ([a-z_]*) (.*)/i;
      final paramSimple2 = ~/@param (\w+) \[([a-z_]*)\]: (.*)/i;
      final paramRegex = ~/@param ([^ ]*)(.*)/i;
      final paramOptional1 = ~/@param (\w+) \(optional, (\w+)\)/i;
      final paramOptional2 = ~/@param (\w+) \[([a-z_]*)\] \(optional\): (.*)/i;
      final paramOptional3 = ~/@param (\w+) \((\w+), optional\)/i;
      final paramWithParens = ~/@param ([^ ]*) \(([^\)]*)\)(.*)/i;

      switch (annotation) {
        case ~/@return Iterator /:
          parsed.set("return", Return("Function")); // TODO: handle real iterator
        case returnWithParens.match(_) => true:
          parsed.set("return", Return(formatTypeStr(returnWithParens.matched(1))));
        case returnRegex.match(_) => true:
          parsed.set("return", Return(formatTypeStr(returnRegex.matched(1))));
        case paramSimple.match(_) => true:
          final name = paramSimple.matched(1);
          final paramType = paramSimple.matched(2);
          parsed.set(name, Param(name, formatTypeStr(paramType)));
        case paramSimple2.match(_) => true:
          final name = paramSimple2.matched(1);
          final paramType = paramSimple2.matched(2);
          parsed.set(name, Param(name, formatTypeStr(paramType)));
        case paramOptional1.match(_) => true:
          final name = paramOptional1.matched(1);
          final paramType = paramOptional1.matched(2);
          parsed.set(name, Param(name, formatTypeStr(paramType)));
        case paramOptional2.match(_) => true:
          final name = paramOptional2.matched(1);
          final paramType = paramOptional2.matched(2);
          parsed.set(name, Param(name, formatTypeStr(paramType)));
        case paramOptional3.match(_) => true:
          final name = paramOptional3.matched(1);
          final paramType = paramOptional3.matched(2);
          parsed.set(name, Param(name, formatTypeStr(paramType)));
        case paramWithParens.match(_) => true:
          final paramName = paramWithParens.matched(1);
          final paramType = formatTypeStr(paramWithParens.matched(2).trim());
          parsed.set(paramName, Param(paramName, paramType));
        case paramRegex.match(_) => true:
          final paramName = paramRegex.matched(1);
          final paramType = formatTypeStr(paramRegex.matched(2).trim());
          switch (paramName) {
            case '$name?':
              parsed.set(name, Optional(name, paramType));
            case name: parsed.set(name, Param(name, paramType));
          }
        case _: "";
      }

      return parsed;
    }, result);
  }

  /**
   * Generates the parameters list for a function.
   * It tries to match the real function arguments with the
   * ones in the documentation, which are provided in the annotations map.
   * If they can not be determined, it will use the type Dynamic.
   */
  static function parseFunctionArgs(annotations:AnnotationMap, args:String) {
    final args:Array< String > = args.split(',').map(StringTools.trim);
    return switch (args) {
      case [''] | []:
        [];
      case args:
        args.map(x -> switch (annotations.get(x)) {
          case Optional(name, type): ['Null<$type>', '?$name'];
          case Param(name, type): [type, name];
          case _: ['Dynamic', x];
        });
    }
  }

  static function parseFunctionBlock(result:FunctionBlock, lines:Array< String >) {
    final regexFn = ~/function ([A-Z._0-9]+)\(([^)]*)/i;
    final weirdFn = ~/\["([^"]*)"\] = function ?\(([^)]*)/i;
    return switch (lines) {
      case []:
        return result;
      case [line, @rest rest]:
        switch (line) {
          case ~/^--- ?@/:
            result.annotations.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case ~/^---? /:
            result.docs.push(line.substr(3));
            return parseFunctionBlock(result, rest);
          case regexFn.match(_) => true:
            final parsedAnnotations = parseAnnotations(result.annotations);
            final fullyQualifiedName = regexFn.matched(1);
            result.name = fullyQualifiedName.split(".").pop();
            result.fullyQualified_name = fullyQualifiedName;
            result.parameters = parseFunctionArgs(parsedAnnotations, regexFn.matched(2));
            result.return_type = switch (parsedAnnotations.get("return")) {
              case Return(type): type;
              case _: 'Void';
            }
            return parseFunctionBlock(result, rest);
          case weirdFn.match(_) => true:
            final parsedAnnotations = parseAnnotations(result.annotations);
            result.name = weirdFn.matched(1);
            result.parameters = parseFunctionArgs(parsedAnnotations, weirdFn.matched(2));
            result.return_type = switch (parsedAnnotations.get("return")) {
              case Return(type): type;
              case _: 'Void';
            }
            return parseFunctionBlock(result, rest);
          case _:
            // Sys.println("WTF " + line);
            return parseFunctionBlock(result, rest);
        }
      case [last]:
        Sys.println("Ignoring last line" + last);
        return result;
      case _:
        throw "Impossible case reached";
    }
  }

  public function parsePath(leafPath) {
    final fnsBlocks = getFunctionBlocks(leafPath);
    return fnsBlocks.fold((x, acc:Array< FunctionBlock >) -> {
      final block = parseFunctionBlock({
        docs: [],
        parameters: [],
        annotations: [],
        name: "",
        fullyQualified_name: "",
        return_type: "Void"
      }, x);
      if (block.name != "" && block.fullyQualified_name != "" && !acc.exists(
        x -> x.name == block.name
      ))
        acc.push(block);
      return acc;
    }, []);
  }

  public function parseFn() {
    final fnsBlocks = getFunctionBlocks('vim.fn.lua').concat(getFunctionBlocks('vim.fn.1.lua'));
    return fnsBlocks.map(x -> parseFunctionBlock({
      docs: [],
      parameters: [],
      annotations: [],
      name: "",
      fullyQualified_name: "",
      return_type: "Void"
    }, x));
  }
}

class ReadNvimApi {
  final outputPath:String;

  public final nvimPath:Result< String >;

  static final luadevRepo = "git@github.com:folke/neodev.nvim.git";

  public function new(outputPath:String) {
    final bytes = readMsgpack();
    this.outputPath = outputPath;
    nvimPath = getNvimRuntime();
  }

  public static function readMsgpack() {
    final readLines = new Process("nvim", ["--api-info"]);

    return readLines.stdout.readAll();
  }

  static function getTmpDir(path) {
    final longTermTempPath = Path.join([getHomeFolder(), '.haxe', path]).absolutePath();
    return try {
      if (!FileSystem.isDirectory(longTermTempPath)) {
        FileSystem.createDirectory(longTermTempPath);
        Ok(longTermTempPath);
      } else {
        Ok(longTermTempPath);
      }
    }
    catch (e) {
      Sys.println('Failed to create $longTermTempPath, fallback to sys temp');
      return executeCommand("mktemp", ["-d", "-t", path]);
    }
  }

  public static function getNvimRuntime() {
    return switch (executeCommand("nvim", [
      "--clean",
      "--headless",
      "--cmd",
      "echo $VIMRUNTIME | qa "
    ], true)) {
      case Error(error):
        Sys.println("Failed to get VIMRUNTIME");
        Sys.println(error);
        Error(error);
      case ok: ok;
    }
  }

  private static function writeFile(outputPath:String, data:Dynamic) {
    final handle = File.write(outputPath, false);
    handle.writeString(Json.stringify(data, null, "  "));
    handle.close();
  }

  static function cleanup(tmpdir) {
    switch (executeCommand("rm", ["-rf", tmpdir])) {
      case Ok(_):
        Sys.println("Cleanup done");
      case Error(error):
        Sys.println("Failed the cleanup process");
        Sys.println(error);
    }
  }

  static function removePrivate(x:FunctionBlock):Bool {
    return !(x.annotations.contains("@private") || x.annotations.contains('@internal'));
  }

  static function main() {
    final tmpDir = switch (Sys.args()) {
      case ['--path', path]:
        Log.print2('Got path: ', path);
        path;
      case _:
        switch (getTmpDir("nvim-api")) {
          case Ok(dirPath):
            Sys.println('Using $dirPath as temp folder');
            dirPath;
          case Error(msg):
            Sys.println('Failed getting temp dir: $msg');
            throw "TMP_DIR_FAIL";
        }
    }
    switch (GitRepo.clone(luadevRepo, tmpDir)) {
      case Ok(output):
        Sys.println("Repo cloned");
        Sys.println(output);
      case Error(err):
        Sys.println(err);
        Sys.println("Failed clone neodev repo");
        return;
    };
    // Extracting info from neodev repository
    final neoDev = new AnnotationParser((leaf) -> Path.join([tmpDir, "types", "stable", leaf]));

    try {
      final parsed = neoDev.parseFn();
      writeFile('./res/fn.json', parsed);
      final api = neoDev.parsePath('api.lua');
      writeFile('./res/api.json', api);
    }
    catch (e) {
      Sys.println(e);
      Sys.println("Error during parsing, proceeding to cleanup");
    }
    final vimApi = new ReadNvimApi('./res/nvim-api.json');
    // vimApi.cleanup(tmpDir);
    switch (vimApi.nvimPath) {
      case Ok(path):
        // Extracting info from neovim runtime path
        final vimBuiltin = new AnnotationParser((leaf) -> Path.join([path, "lua", "vim", leaf]));
        final parsed = vimBuiltin.parsePath('fs.lua');
        writeFile('./res/fs.json', parsed);
        final lsp = vimBuiltin.parsePath('lsp.lua').filter(removePrivate);
        writeFile('./res/lsp.json', lsp);
        final lspBuf = vimBuiltin.parsePath('lsp/buf.lua').filter(removePrivate);
        writeFile('./res/lsp_buf.json', lspBuf);
        // This bad boy breaks the parsing for some reason
        final filetypeContent = File.getBytes(Path.join([path, 'lua', 'vim', 'filetype.lua']));
        final parser = new LuaParser(ByteData.ofBytes(filetypeContent), 'filetype.lua');
        var parsed = parser.parse();
        final fileTypeTypes = [];
        try {
          while (parsed != Tok.Eof) {
            fileTypeTypes.push(parsed);
            parsed = parser.parse();
          }
        }
        catch (e) {
          Log.print2("Failed while parsing filetype.lua: ", e);
        }
        Log.print2("parsed =====> ", fileTypeTypes);
        Log.print("===== Parsing done ===== ");
      // writeFile('./res/filetype.json', fileTypeTypes);

      case Error(error):
        Sys.println("Could not get neovim path, skip parsing");
        Sys.println(error);
    }
  }
}
