package tools.luaParser;

import hxparse.Lexer;
import haxe.macro.Expr.Position;

using StringTools;
using Safety;

enum LKeyword {
  And;
  Break;
  Do;
  Else;
  Elseif;
  End;
  False;
  For;
  Function;
  Goto;
  If;
  In;
  Local;
  Nil;
  Not;
  Or;
  Repeat;
  Return;
  Then;
  True;
  Until;
  While;
}

final luaKeywords:Map< String, LKeyword > = [
  "and" => LKeyword.And,
  "break" => LKeyword.Break,
  "do" => LKeyword.Do,
  "else" => LKeyword.Else,
  "elseif" => LKeyword.Elseif,
  "end" => LKeyword.End,
  "false" => LKeyword.False,
  "for" => LKeyword.For,
  "function" => LKeyword.Function,
  "goto" => LKeyword.Goto,
  "if" => LKeyword.If,
  "in" => LKeyword.In,
  "local" => LKeyword.Local,
  "nil" => LKeyword.Nil,
  "not" => LKeyword.Not,
  "or" => LKeyword.Or,
  "repeat" => LKeyword.Repeat,
  "return" => LKeyword.Return,
  "then" => LKeyword.Then,
  "true" => LKeyword.True,
  "until" => LKeyword.Until,
  "while" => LKeyword.While,
];

enum TokenDef {
  Dot;
  ThreeDots;
  DotDot;
  Eof;
  NotEqual;
  LengthSharp;
  Comment(content:String);
  LuaDocParam(content:String);
  LuaDocReturn(content:String);
  LuaDocPrivate;
  Keyword(k:LKeyword);
  Identifier(name:String);
  Namespace(name:String);
  StringLiteral(content:String);
  IntegerLiteral(value:String);
  FloatLiteral(value:String);
  HexLiteral(value:String);
  Newline;
  OpenParen;
  CloseParen;
  CurlyOpen;
  CurlyClose;
  SquareOpen;
  SquareClose;
  Comma;
  Colon;
  Semicolon;
  Plus;
  Minus;
  Asterisk;
  Slash;
  Percent;
  Hat;
  Equal;
  Equality;
  LessThan;
  BiggerThan;
  LessEqual;
  BiggerEqual;
}

class Token {
  public var tok:TokenDef;
  public var pos:Position;
  public var space = "";

  public function new(tok, pos) {
    this.tok = tok;
    this.pos = pos;
  }

  public function toString() {
    return switch (tok) {
      case Comment(content): 'Comment("$content")';
      case LuaDocParam(content): 'LuaDocParam("$content")';
      case LuaDocReturn(doc): 'LuaDocReturn("$doc")';
      case Keyword(k): 'Keyword($k)';
      case Identifier(name): 'Identifier("$name")';
      case StringLiteral(content): 'StringLiteral("$content")';
      case IntegerLiteral(value): 'IntegerLiteral("$value")';
      case FloatLiteral(value): 'FloatLiteral("$value")';
      case HexLiteral(value): 'HexLiteral("$value")';
      case other: '$other';
    }
  }
}

class LuaLexer extends Lexer implements hxparse.RuleBuilder {
  static public var ignoreComments = false;

  static function mkPos(p:hxparse.Position) {
    return {
      file: p.psource,
      min: p.pmin,
      max: p.pmax
    };
  }

  static function mk(lexer:Lexer, td) {
    return new Token(td, mkPos(lexer.curPos()));
  }

  static final identifier_ = "[a-zA-Z_][a-zA-Z0-9_]*";
  static final integer = "[0-9]+";
  static final float = "[0-9]+\\.[0-9]([eE][-+]?[0-9]+)?";
  static final hex = "0[xX][0-9a-fA-F]+";

  public static var consumeLine = @:rule ["[^\n]+" => lexer.current];
  // @:rule wraps the expression to the right of => with function(lexer) return
  public static var tok = @:rule [
    "return" => mk(lexer, Keyword(LKeyword.Return)),
    "\\+" => mk(lexer, Plus),
    ";" => mk(lexer, Semicolon),
    "\\-" => mk(lexer, Minus),
    "\\*" => mk(lexer, Asterisk),
    "\\/" => mk(lexer, Slash),
    "%" => mk(lexer, Percent),
    "\\^" => mk(lexer, Hat),
    "\\.\\.\\." => mk(lexer, ThreeDots),
    "\\.\\." => mk(lexer, DotDot),
    "\n\n" => mk(lexer, Newline),
    "\n" => lexer.token(tok),
    hex => mk(lexer, HexLiteral(lexer.current)),
    float => mk(lexer, FloatLiteral(lexer.current)),
    integer => mk(lexer, IntegerLiteral(lexer.current)),
    "[\t ]+" => {
      var space = lexer.current;
      var token:Token = lexer.token(tok);
      token.space = space;
      token;
    },
    "<=" => mk(lexer, LessEqual),
    ">=" => mk(lexer, BiggerEqual),
    "<" => mk(lexer, LessThan),
    ">" => mk(lexer, BiggerThan),
    "#" => mk(lexer, LengthSharp),
    "\\[" => mk(lexer, SquareOpen),
    "\\]" => mk(lexer, SquareClose),
    "\\{" => mk(lexer, CurlyOpen),
    "\\}" => mk(lexer, CurlyClose),
    "\\(" => mk(lexer, OpenParen),
    "\\)" => mk(lexer, CloseParen),
    "," => mk(lexer, Comma),
    "==" => mk(lexer, Equality),
    "=" => mk(lexer, Equal),
    "~=" => mk(lexer, NotEqual),
    ":" => mk(lexer, Colon),
    "\\[\\[" => {
      final content = lexer.token(longBracketString);
      mk(lexer, StringLiteral(content));
    },
    "'" => {
      final content = lexer.token(singleQuotedString);
      mk(lexer, StringLiteral(content));
    },
    "\"" => {
      final content = lexer.token(doubleQuotedString);
      mk(lexer, StringLiteral(content));
    },
    identifier_ => {
      final content = lexer.current;
      final keyword = luaKeywords.get(content);
      if (keyword != null) {
        mk(lexer, Keyword(keyword));
      } else {
        mk(lexer, Identifier(content));
      }
    },
    "\\." => mk(lexer, Dot),
    "--- ?@param" => {
      final content = lexer.token(consumeLine);
      mk(lexer, LuaDocParam(content));
    },
    "--- ?@return" => {
      final content = lexer.token(consumeLine);
      mk(lexer, LuaDocReturn(content));
    },
    "--- ?@private" => {
      mk(lexer, LuaDocPrivate);
    },
    "---?[^@]" => {
      final content = lexer.token(consumeLine);
      if (ignoreComments) {
        return lexer.token(tok);
      }
      mk(lexer, Comment(content));
    },
    "" => mk(lexer, Eof),
  ];

  public static var longBracketString = @:rule ["\\]\\]" => "", "[^\\]]+" => {
    final content = lexer.current;
    content + lexer.token(longBracketString);
  }];
  public static var singleQuotedString = @:rule ["[^']+" => {
    final content = lexer.current;
    content + lexer.token(singleQuotedString); // make sure to consume the closing quote
  }, "'" => ""];
  public static var doubleQuotedString = @:rule ["[^\"]+" => {
    final content = lexer.current;
    content + lexer.token(doubleQuotedString); // make sure to consume the closing quote
  }, "\"" => ""];
}
