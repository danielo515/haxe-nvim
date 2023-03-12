package tools.luaParser;

import sys.FileSystem;
import haxe.ds.StringMap;
import haxe.Json;
import tools.FileTools;
import haxe.io.Path;
import sys.io.File;
import byte.ByteData;
import tools.luaParser.LuaDoc;

using haxe.EnumTools;
using haxe.macro.ExprTools;
using StringTools;
using Lambda;

// Prevent generating tests for the same comment twice
final globallyViewedComments = new StringMap< Bool >();

function readNeovimLuaFile(relativePath:String):Array< String > {
  final runtimePath = FileTools.getNvimRuntimePath();
  switch (runtimePath) {
    case Error(e):
      throw e;
    case Ok(path):
      final contents = File.getContent(Path.join([path, 'lua', relativePath]));
      return contents.split('\n');
  }
}

@:tink class EnuP {
  static public function printEnum(e:EnumValue) {
    final name = e.getName();
    final values = EnumValueTools.getParameters(e);
    if (values.length == 0) {
      return name;
    }
    return switch values[0] {
      case(v : String): '$name("$v")';
      default: '$name($values)';
    }
  }
}

function generateTestCase(fixture, original, expected:ParamDoc) {
  // final expected = [${expected.map(EnuP.printEnum).join(', ')}];
  final contents = '
  it("$original => ${expected.name}: ${expected.type}", {
      final parser = new LuaDocParser(ByteData.ofString("$fixture"));
      final actual = parser.parse();
      final expected = Json.stringify(${Json.stringify(expected)});
      Json.stringify(actual).should.be(expected);
  });';
  return contents;
};

function generateTestSuite(referenceFile:String, testCases) {
  final contents = 'describe("$referenceFile", {
    ${testCases.join("\n\t")}
  });';
  return contents;
};

function generateTestFile(testSuites) {
  final contents = '
    package tools.luaParser;

    import byte.ByteData;
    import haxe.Json;
    import tools.luaParser.LuaDoc;

    using StringTools;
    using buddy.Should;

    @colorize
    class LuaDocParserTest extends buddy.SingleSuite {
      public function new() { ${testSuites.join("\n\t")}
      }
    }
  ';

  return contents;
}

typedef MatchStr = {line:String, match:String};

function extractAllParamCommentsFromFile(file:String):Array< MatchStr > {
  final lines = readNeovimLuaFile(file);
  final comments = [];
  final commentRegex = ~/-{2,3} ?@param (.*)/;
  for (line in lines) {
    if (commentRegex.match(line)) {
      final matched = commentRegex.matched(1);
      if (globallyViewedComments.exists(matched)) {
        continue;
      }
      globallyViewedComments.set(matched, true);
      comments.push({line: line, match: matched});
    }
  }
  final filteredComments = comments.filter((str) -> {
    // Yes, this ridiculous thing is there
    !str.line.contains("(context support not yet implemented)");
  });
  return filteredComments;
}

function parseParamComment(comment:MatchStr) {
  final parser = new LuaDocParser(ByteData.ofString(comment.match));
  Log.prettyPrint("=====", comment.line);
  final parseResult = parser.parse();
  Log.prettyPrint('', parseResult);
  return parseResult;
}

function generateTestCases(commentsAsStrings:Array< MatchStr >) {
  final commentsParsed = commentsAsStrings.map(parseParamComment);
  final testCases = [for (idx => expected in commentsParsed) {
    final fixture = commentsAsStrings[idx];
    generateTestCase(fixture.match, fixture.line, expected);
  }];
  return testCases;
}

function generateTestCasesFromRuntimeFiles() {
  final files = [
    'vim/filetype.lua',
    'vim/fs.lua',
    'vim/keymap.lua',
    'vim/lsp/buf.lua'
  ];
  final testSuites = [for (file in files) {
    final commentsAsStrings = extractAllParamCommentsFromFile(file);
    final testCases = generateTestCases(commentsAsStrings);
    generateTestSuite(file, testCases);
  }];
  return testSuites;
}

/**
  Uses our existing json files already extracted to generate test 
  against them.
 */
function generateTestCasesFromJsonResFiles() {
  final files = ['fn.json', 'api.json',];
  final commentRegex = ~/ ?@param (.*)/;
  final testSuites = [for (file in files) {
    final specs:Array< {annotations:Array< String >} > = Json.parse(
      File.getContent(FileTools.getResPath(file))
    );
    final commentsAsStrings = specs.flatMap((spec) -> {
      spec.annotations.flatMap((line) -> {
        if (commentRegex.match(line)) {
          final match = commentRegex.matched(1);

          if (globallyViewedComments.exists(match)) {
            return [];
          }
          globallyViewedComments.set(match, true);
          [{line: line, match: match}];
        } else {
          [];
        };
      });
    });
    final testCases = generateTestCases(commentsAsStrings);
    generateTestSuite(file, testCases);
  }];
  return testSuites;
}

function main() {
  final testSuites = generateTestCasesFromRuntimeFiles();
  final testSuitesFromJson = generateTestCasesFromJsonResFiles();
  final testFile = generateTestFile(testSuites.concat(testSuitesFromJson));
  final destinationFile = FileSystem.absolutePath(Path.join([
    FileTools.getDirFromPackagePath('tools/Cmd.hx'),
    '/luaParser/LuaDocParserTest.hx'
  ]));
  writeTextFile(destinationFile, testFile);
  Cmd.executeCommand('haxelib', ['run', 'formatter', '-s', destinationFile]);
  // final parsed = new LuaDocParser(
  //   ByteData.ofString('bufnr string The buffer to get the lines from')
  // ).parse();
  // Log.prettyPrint("parsed", parsed);
};
