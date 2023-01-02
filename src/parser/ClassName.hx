package parser;

typedef Tokens = Array< String >;

enum State {
	Initial;
	Finished(tokens:Tokens);
	Running(buffer:String, position:Int);
}

class Parser {
	private final string:String;
	private final checker:String -> Bool;
	private var state:State;
	private var tokens:Array< String >;

	public function new(str:String, checker) {
		this.string = str;
		this.state = Initial;
		this.tokens = [];
		this.checker = checker;
	}

	public function seek() {
		var nextChar = switch (this.state) {
			case Initial: string.charAt(0);
			case Running(_, pos): string.charAt(pos);
			case Finished(_): "";
		}
		return nextChar;
	}

	public function advance() {
		this.state = switch (this.state) {
			case Finished(tokens): Finished(tokens);
			case Initial: Running("", 1);
			case Running(buffer, pos):
				if (pos + 1 >= this.string.length) {
					this.tokens.push(buffer);
					Finished([]);
				} else Running(buffer, pos + 1);
		}
		return switch (this.state) {
			case Finished(_): this.tokens;
			case Initial | Running(_):
				this.tokenize();
		}
	}

	public function tokenize() {
		var nextChar = this.seek();
		var isValidChar = this.checker(nextChar);
		this.state = switch ([isValidChar, this.state]) {
			case [true, Running(buffer, pos)]:
				Running(buffer + nextChar, pos);
			case [false, Running(buffer, pos)]:
				this.tokens.push(buffer);
				Running("", pos);
			case [true, Initial]:
				Running(nextChar, 0);
			case [false, Initial]:
				Running("", 0);
			case [_, Finished(tokens)]:
				Finished(tokens);
		}
		return this.advance();
	}
}

@:expose
class ClassName {
	private final parser:Parser;

	private static function isNotWhitespace(arg) {
		return arg != " ";
	}

	public function new(str:String) {
		this.parser = new Parser(str, isNotWhitespace);
	}

	private function parse() {
		return this.parser.tokenize();
	}

	public static function main() {
		var res = new ClassName("a be x-pene nabo:99").parse();
		trace(res);
	}
}
