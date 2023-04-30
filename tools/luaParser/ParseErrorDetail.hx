package tools.luaParser;

class ParseErrorDetail extends hxparse.ParserError {
  public final message:String;

  public function new(pos:hxparse.Position, msg:String) {
    super(pos);
    this.message = msg;
  }

  override function toString() {
    return "Parse error: " + message;
  }
}
