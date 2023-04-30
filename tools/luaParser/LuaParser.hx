package tools.luaParser;

/**
  This is a very specific parser for Lua files within the NeoVim context.
  It is used to extract function signatures from Lua files for use in haxe-nvim.
  It is not meant to be able to parse real Lua code, or do any smart inference around it.
  It will only parse top level functions, and will not parse any nested code, that will be ignored.
**/
import byte.ByteData;
import tools.luaParser.Lexer;
import haxe.Json;
import tools.luaParser.LuaDoc;
import hxparse.ParserError.ParserError;

using StringTools;

typedef FunctionDefinition = {
  name:String,
  namespace:Array< String >,
  args:Array< String >,
  typedArgs:Array< ParamDoc >,
  description:String,
  returnDoc:ReturnDoc,
  isPrivate:Bool,
};

enum Tok {
  FunctionWithDocs(definition:FunctionDefinition);
  CommentBlock(desc:String, luaDoc:Array< String >);
  Eof;
}

class LuaParser extends hxparse.Parser< hxparse.LexerTokenSource< Token >, Token > implements hxparse.ParserBuilder {
  final input:ByteData;

  public function new(input:byte.ByteData, sourceName = "") {
    this.input = input;
    var lexer = new LuaLexer(input, sourceName);
    var ts = new hxparse.LexerTokenSource(lexer, LuaLexer.tok);
    super(ts);
  }

  function dumpAtCurrent() {
    ParseDump.dumpAtCurrent(stream.curPos(), this.input, this.last.toString());
  }

  final public function parse():Tok {
    try {
      // This is so we can use the same body for both the private and public functions
      inline function parseFunctionWithDocs(isPrivate = false) {
        switch stream {
          case [{tok: Comment(content)}]:
            final comments = parseBlockComment([content], []);
            final func = parseOptional(parseFunction);
            if (func == null) {
              Log.print('Ignoring comment block');
              return null;
            }
            return FunctionWithDocs({
              name: func.name,
              namespace: func.namespace,
              args: func.args,
              typedArgs: comments.luaDoc,
              description: comments.description,
              isPrivate: isPrivate,
              returnDoc: comments.returnDoc
            });
          case [fn = parseFunction()]:
            return FunctionWithDocs({
              name: fn.name,
              namespace: fn.namespace,
              args: fn.args,
              typedArgs: [],
              description: "",
              isPrivate: isPrivate,
              returnDoc: null,
            });
        }
      }
      while (true) {
        LuaLexer.ignoreComments = false;
        switch stream {
          case [{tok: LuaDocPrivate}]:
            final fn = parseFunctionWithDocs(true);
            if (fn == null) {
              continue;
            }
            return fn;
          case [fn = parseFunctionWithDocs(false)]:
            if (fn == null) {
              continue;
            }
            return fn;
          case [{tok: Eof}]:
            return Tok.Eof;
          case [table = parseTableConstructor()]:
            Log.print('Ignoring top level table: "$table"');
            continue;
          case [x]:
            Log.print('Ignoring top level token: "$x"');
            continue;
        }
      }
    }
    catch (e:ParserError) {
      Log.print('Parser error: "$e"');
      dumpAtCurrent();
      throw e;
    }
  };

  // 	funcname ::= Name {`.´ Name} [`:´ Name]
  public function parseFunctionName(namespace:Array< String >) {
    return switch stream {
      case [{tok: Identifier(name)}]:
        switch stream {
          case [{tok: Dot}]:
            parseFunctionName(namespace.concat([name]));
          case [{tok: Colon}]:
            parseFunctionName(namespace.concat([name]));
          case _: {name: name, namespace: namespace};
        }
    }
  }

  public function parseFunction() {
    return switch stream {
      case [{tok: Keyword(Local)},]:
        switch stream {
          case [{tok: Keyword(Function)}, ident = parseFunctionName([])]:
            final args = parseArgs();
            ignoreFunctionBody(1);
            {name: ident.name, namespace: ident.namespace, args: args};
        }
      case [{tok: Keyword(Function)}, ident = parseFunctionName([])]:
        final args = parseArgs();
        ignoreFunctionBody(1);
        {name: ident.name, namespace: ident.namespace, args: args};
    }
  }

  /**
    I told you at the top of the file, we only parse top level stuff.
    This will ignore everytihing withint the function body, even other functions
   */
  public function ignoreFunctionBody(nestLevel:Int) {
    return switch stream {
      // This are the tokens that can add a nest level that is dependent on the End token
      // so we account for them in order to know when the function body ends
      case [
        {tok: Keyword(If | For | While | Until | Function)}
      ]:
        ignoreFunctionBody(nestLevel + 1);
      case [{tok: Keyword(End)}]:
        if (nestLevel == 1) {
          return;
        }
        ignoreFunctionBody(nestLevel - 1);
      // just doing `case _:` does not consume the token
      case [_]:
        ignoreFunctionBody(nestLevel);
    }
  }

  function parseBlockComment(description:Array< String >, luaDoc:Array< ParamDoc >) {
    return switch stream {
      case [{tok: Comment(content)}]:
        description.push(content);
        parseBlockComment(description, []);
      case [{tok: LuaDocParam(param)}]:
        final paramParsed = new LuaDocParser(ByteData.ofString(param)).parse();
        luaDoc.push(paramParsed);
        parseBlockComment(description, luaDoc);
      case [{tok: LuaDocReturn(content)}]:
        final returnParsed = new LuaDocParser(ByteData.ofString(content.trim())).parseReturn();
        {description: description.join('\n'), luaDoc: luaDoc, returnDoc: returnParsed}
      case _: {description: description.join('\n'), luaDoc: luaDoc, returnDoc: null};
    }
  }

  public function parseArgs():Array< String > {
    return switch stream {
      case [{tok: OpenParen}]:
        var args = parseSeparated(tok -> tok.tok == Comma, parseIdent);
        switch stream {
          case [{tok: CloseParen}]:
            args;
        }
    }
  };

  public function parseIdent():String {
    return switch stream {
      case [{tok: ThreeDots}]:
        "kwargs";
      case [{tok: Identifier(name)}]:
        name;
    }
  }

  public function parseTableConstructor() {
    Log.print('parseTableConstructor');
    // TODO: use a different ruleset This is dirty and awful
    LuaLexer.ignoreComments = true;
    return switch stream {
      case [
        {tok: CurlyOpen},
        f = parseOptional(parseFieldList),
        {tok: CurlyClose}
      ]:
        f;
    }
  }

  // fieldlist ::= field {fieldsep field} [fieldsep]
  public function parseFieldList() {
    trace('parseFieldList');
    final fields = [];
    while (true) {
      switch stream {
        case [field = parseField()]:
          fields.push(field);
        case [{tok: Comma}, field = parseOptional(parseField)]:
          if (field == null) {
            return fields;
          }
          fields.push(field);
      }
    }
  }

  //	field ::= `[´ exp `]´ `=´ exp | Name `=´ exp | exp
  public function parseField() {
    trace('parseField');
    optionallyIgnoreComments();
    return switch stream {
      case [
        {tok: SquareOpen},
        expr = parseExpression(),
        {tok: SquareClose},
        {tok: Equal},
        value = parseExpression()
      ]:
        trace('parsed field: $expr = $value');
        {key: expr, value: value};
      case [{tok: Identifier(key)}, {tok: Equal}, value = parseExpression()]:
        trace('parsed field: $key = $value');
        {key: key, value: value};
      case [expr = parseExpression()]:
        switch stream {
          case [{tok: Equal}, value = parseExpression()]:
            {key: expr, value: value};
          case _:
            {key: null, value: expr};
        }
    }
  }

  public function optionallyIgnoreComments():Void {
    while (true) {
      switch stream {
        case [{tok: Comment(content)}]:
          Log.print('Ignoring comment: "$content"');
        case _:
          return;
      }
    }
  }

  public function paseBinop(left) {
    trace('paseBinop');
    return switch stream {
      case [{tok: DotDot | Plus}, right = parseExpression()]:
        {left: left, right: right};
    }
  }

  public function parseNumber() {
    return switch stream {
      case [{tok: Minus}]:
        "-" + parseNumber();
      case [{tok: IntegerLiteral(value)}]:
        value;
    }
  }

  /*
    exp ::=  nil | false | true | Number | String | `...´ | function | 
       prefixexp | tableconstructor | exp binop exp | unop exp
   */
  public function parseExpression() {
    trace('parseExpression');
    final exp = switch stream {
      case [{tok: StringLiteral(value)}]: value;
      case [value = parseNumber()]: value;
      case [{tok: Keyword(False | True)}]: 'Bool';
      case [{tok: Keyword(Nil)}]: 'Null';
      case [{tok: Keyword(Function)}, args = parseArgs()]:
        ignoreFunctionBody(1);
        "AnonFunction";
      case [table = parseTableConstructor()]:
        trace('nested table', table);
        'table';
      case [functionCall = parseFunctionCall()]:
        functionCall.name;
      case [prefix = parsePrefixExp()]:
        prefix;
    }
    return switch (peek(1).tok) {
      case DotDot | Plus:
        Json.stringify(paseBinop(exp));
      case _: exp;
    }
  }

  // varSuffix ::= `[´ exp `]´ | `.´ Name
  public function parseVarSuffix() {
    trace('parseVarSuffix');
    optionallyIgnoreComments();
    return switch stream {
      case [{tok: SquareOpen}, expr = parseExpression(), {tok: SquareClose}]:
        '[' + expr + ']';
      case [{tok: Dot}, {tok: Identifier(name)}]:
        '.' + name;
    }
  }

  // var ::= Name | varSuffix
  public function parseVar() {
    trace('parseVar');
    return switch stream {
      case [{tok: Identifier(name)}]:
        name;
      case [suffix = parseVarSuffix()]:
        suffix;
    }
  }

  // prefixexp ::= Name | `(´ exp `)´ | prefixexp varSuffix | var `[´ exp `]´ | var `.´ Name
  public function parsePrefixExp() {
    trace('parsePrefixExp');
    return switch stream {
      case [{tok: Identifier(name)}]:
        switch stream {
          case [suffix = parseOptional(parseVarSuffix)]:
            name + suffix + parseOptional(parseVarSuffix);
          case _:
            name;
        }
      case [{tok: OpenParen}, expr = parseExpression(), {tok: CloseParen}]:
        expr;
      case [suffix = parseVarSuffix()]:
        suffix;
    }
  }

  // functioncall ::=  prefixexp args | prefixexp `:´ Name args
  public function parseFunctionCall() {
    return switch stream {
      case [
        name = parsePrefixExp(),
        {tok: OpenParen},
        args = parseSeparated(tok -> tok.tok == Comma, parseExpression),
        {tok: CloseParen}
      ]:
        {name: name, args: args};
    }
  }
}
