package tools.luaParser;

import haxe.Json;
import byte.ByteData;
import hxparse.Lexer;
import hxparse.ParserError.ParserError;

using StringTools;
using Safety;

typedef Param = {
  final type:String;
  final description:String;
}

enum TypeToken {
  TFunction;
  Number;
  String;
  Table;
  Boolean;
  Nil;
  Colon;
  Any;
  TVarArgs;
  TIdentifier(name:String);
  WindowId;
  BufferId;
  Dynamic;
}

enum DocToken {
  Identifier(name:String);
  Description(text:String);
  DocType(type:TypeToken);
  ArrayMod;
  OptionalMod;
  Comma;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  Lparen;
  Rparen;
  TypeOpen;
  TypeClose;
  Pipe;
  SPC;
  EOL;
}

class LuaDocLexer extends Lexer implements hxparse.RuleBuilder {
  static var ident = "[a-zA-Z_][a-zA-Z0-9_]*";

  public static var desc = @:rule [
    "[^\n]*" => Description(lexer.current.ltrim()),
    "" => EOL
  ];
  public static var paramDoc = @:rule [
    ident => {final name = lexer.current.ltrim().rtrim(); Identifier(name);},
    " " => SPC,
    "" => EOL,
    "\\.\\.\\." => Identifier("kwargs"),
    "\\?" => OptionalMod,
  ];
  public static var typeDoc = @:rule [
    " " => SPC,
    // " " => lexer.token(typeDoc),
    ", ?" => Comma,
    "\\[\\]" => ArrayMod,
    "\\?" => OptionalMod,
    "<" => TypeOpen,
    ">" => TypeClose,
    "{" => CurlyOpen,
    "}" => CurlyClose,
    "[" => SquareOpen,
    "]" => SquareClose,
    "\\(" => Lparen,
    "\\)" => Rparen,
    "\\|" => Pipe,
    "number" => DocType(TypeToken.Number),
    "string" => DocType(TypeToken.String),
    "table" => DocType(TypeToken.Table),
    "boolean" => DocType(TypeToken.Boolean),
    "function" => DocType(TypeToken.TFunction),
    "fun" => DocType(TypeToken.TFunction),
    "any" => DocType(Any),
    "window" => DocType(WindowId),
    "buffer" => DocType(BufferId),
    "object" => DocType(TypeToken.Dynamic),
    // Don't judge me
    "fun\\(\\)" => DocType(TypeToken.TFunction),
    "nil" => DocType(Nil),
    ":" => DocType(Colon),
    ident => DocType(TIdentifier(lexer.current)),
    ", ?optional" => OptionalMod,
    "\\.\\.\\." => DocType(TVarArgs),
    "" => EOL,
  ];
}

typedef ParamDoc = {
  final name:String;
  final type:String;
  final description:String;
  final isOptional:Bool;
}

class LuaDocParser extends hxparse.Parser< hxparse.LexerTokenSource< DocToken >, DocToken > implements hxparse.ParserBuilder {
  private final inputAsString:byte.ByteData;

  public function new(input:byte.ByteData) {
    inputAsString = (input);
    var lexer = new LuaDocLexer(input);
    var ts = new hxparse.LexerTokenSource(lexer, LuaDocLexer.paramDoc);
    super(ts);
  }

  public function dumpAtCurrent() {
    final pos = stream.curPos();
    final max:Int = inputAsString.length - 1;
    Log.print2("> Last parsed token: ", this.last);
    Log.print2("> ", inputAsString.readString(0, max));
    final cursorWidth = (pos.pmax - pos.pmin) - 1;
    final padding = 2;
    Log.print("^".lpad(" ", pos.pmin + padding) + "^".lpad(" ", cursorWidth + padding));
    // Log.print("^".lpad(" ", pos.pmax + 2));
  }

  public function parse():ParamDoc {
    return switch stream {
      case [SPC]: parse();
      case [Identifier(name)]:
        final isOptional = if (peek(0) == OptionalMod) {
          junk();
          true;
        } else {
          false;
        };
        switch stream {
          case [EOL]:
            return {
              name: name,
              type: "Any",
              description: "",
              isOptional: isOptional
            };
          case [SPC]:
            stream.ruleset = LuaDocLexer.typeDoc;
            try {
              Log.print("About to parse types");
              final t = parseType();
              Log.print("Parsed types");
              stream.ruleset = LuaDocLexer.desc;
              if (peek(0) == SPC) {
                junk();
              } else {
                Log.print("WARNING: No space after types");
              }
              final text = parseDesc();
              return {
                name: (isOptional ? "?" : "") + name,
                type: t,
                description: text,
                isOptional: isOptional,
              };
            }
            catch (e:ParserError) {
              Log.print2("Error parsing: \n\t", e);
              dumpAtCurrent();
              Log.print2("line", e.pos.format(inputAsString));
              throw(e);
            }
          case _:
            trace("Expecting identifier, dup state", null);
            dumpAtCurrent();
            throw "Unexpected token";
        }
    }
  }

  public function parseType() {
    return switch stream {
      case [Lparen, t = parseType()]: // This is ridiculous, but neovim people thinks is nice
        Log.print("Hey within parens");
        switch stream {
          case [OptionalMod]: '?$t';
          case [Rparen]:
            '$t';
          case _: throw("Unclosed parenthesis");
        }
      case [DocType(Table)]:
        switch stream {
          case [TypeOpen, t = parseTypeArgs(), TypeClose]:
            'Table<$t>';
          case [Pipe]:
            Log.print("Hey Pipe next to table");
            parseEither("Table");
          case _: 'Table';
        }
      case [CurlyOpen, t = parseObj(new Map())]:
        '$t';
      case [DocType(TFunction)]: switch stream {
          case [Lparen, t = parseFunctionArgs()]: '$t';
          case [Pipe, e = parseEither('Function')]: e;
          case _: 'Function';
        }
      case [DocType(t)]:
        switch stream {
          case [ArrayMod]: 'Array<$t>';
          case [OptionalMod]: '?$t';
          case [Pipe, e = parseEither('$t')]: e;
          case _: '$t';
        }
    }
  }

  public function parseTuple(size, arg) {
    return switch stream {
      case [Comma, t = parseType()]:
        parseTuple(size + 1, arg + ',' + t);
      case [CurlyClose]:
        'Vector$size<$arg>';
    }
  }

  public function parseObj(acc:Map< String, String >) {
    return switch stream {
      case [DocType(t)]:
        parseTuple(1, '$t');
      case [Identifier(name), DocType(Colon), t = parseType()]:
        acc.set(name, t);
        switch stream {
          case [CurlyClose]: 'Obj(${Json.stringify(acc)})';
          case [Comma]:
            parseObj(acc);
        }
    }
  }

  public function parseFunctionArgs() {
    return switch stream {
      case [DocType(TIdentifier(name)), DocType(Colon)]:
        // We should discard spaces that may be separating argument and type
        if (peek(0) == SPC)
          junk();
        final t = parseType();
        // account for potential return type
        final returnType = switch [peek(0), peek(1), peek(2)] {
          case [Rparen, DocType(Colon), SPC]:
            // I need to manually consume them because we are not in a stream switch
            junk();
            junk();
            junk();
            parseType();
          case [Rparen, DocType(Colon), _]:
            junk();
            junk();
            parseType();
          case _: 'Void';
        }
        'FunctionWithArgs($name: $t):$returnType';
    }
  }

  public function parseEither(left) {
    return switch stream {
      case [DocType(t)]:
        switch stream {
          case [Pipe, e = parseType()]: 'Either<$left, $e>';
          case _:
            'Either<$left, $t>';
        }
    };
  }

  public function parseTypeArgs() {
    Log.print("Hey table args parsing");
    return switch stream {
      case [DocType(t)]:
        if (peek(0) == Comma) {
          junk();
          t + ',' + parseTypeArgs();
        } else {
          t + '';
        }
    };
  }

  public function parseDesc() {
    Log.print("Hey desc parsing");
    return switch stream {
      case [Description(text), EOL]:
        text;
      // Yeah, seems description is optional too
      case [EOL]:
        '';
    }
  }
}
