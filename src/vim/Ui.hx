package vim;

import vim.VimTypes;
import haxe.Constraints.Function;

typedef SelectConfig = TableWrapper< {
  prompt:String
} >

typedef InputOpts = TableWrapper< {
  prompt:String,
  completion:() -> LuaArray< String >
} >

@:native('vim.ui')
extern class Ui {
  static function select(
    options:LuaArray< String >,
    config:SelectConfig,
    onSelect:(Null< String >, Null< Int >) -> Void
  ):Void;
  static function input(options:InputOpts, on_confirm:(Null< String >) -> Void):Void;
}
