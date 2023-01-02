package vim;

import vim.VimTypes;
import haxe.Constraints.Function;

typedef SelectConfig = TableWrapper< {
  prompt:String
} >

@:native('vim.ui')
extern class Ui {
  static function select(
    options:LuaArray< String >,
    config:SelectConfig,
    onSelect:(Null< String >, Null< Int >) -> Void
  ):Void;
}
