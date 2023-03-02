package vim;

import vim.types.WOpts;
import haxe.extern.EitherType;
import haxe.Rest;
import vim.VimTypes;
import haxe.Constraints.Function;
import lua.Table;

inline function comment() {
  untyped __lua__("---@diagnostic disable");
}

@:native("vim.fs")
@:build(ApiGen.attachApi("fs"))
extern class Fs {}

@:native("vim.fn")
@:build(ApiGen.attachApi("fn"))
extern class Fn {
  static function expand(string:ExpandString):String;
  static function fnamemodify(file:String, string:PathModifier):String;
  static function executable(binaryName:String):Int;
  static function json_encode(value:Dynamic):String;
  static function json_decode(json:String):Table< String, Dynamic >;
}

@:native("vim.keymap")
extern class Keymap {
  /*Set a keymap in one or more modes*/
  public static function set(
    mode:EitherType< VimMode, LuaArray< VimMode > >,
    keys:String,
    map:EitherType< Function, String >,
    opts:TableWrapper< {desc:String, silent:Bool, expr:Bool} >
  ):Void;

  @:native('set')
  public static function setBuf(
    mode:VimMode,
    keys:String,
    map:EitherType< Function, String >,
    opts:TableWrapper< {desc:String, buffer:Buffer} >
  ):Void;
}

@:native("vim")
extern class Vim {
  public static final o:vim.types.Opt;
  public static final go:vim.types.GOpt;
  public static final g:VimGOpts;
  public static final wo:WOpts;
  @:native("pretty_print")
  static function print(args:Rest< Dynamic >):Void;
  static inline function expand(string:ExpandString):String {
    return Fn.expand(string);
  };
  public static function tbl_map< T, B >(fn:T -> B, tbl:LuaArray< T >):LuaArray< B >;
  public static function list_extend< T >(dest:LuaArray< T >, src:LuaArray< T >):LuaArray< T >;
  public static function cmd(command:String):Void;
  public static function notify(message:String, level:String):Void;
}

abstract Vector3< A, B, C >(lua.Table< Int, Dynamic >) {
  inline public function first():A {
    return this[1];
  }

  inline public function second():B {
    return this[2];
  }

  inline public function last():C {
    return this[3];
  }
}

abstract Vector4< A, B, C, D >(lua.Table< Int, Dynamic >) {
  inline public function first():A {
    return this[1];
  }

  inline public function second():B {
    return this[2];
  }

  inline public function third():C {
    return this[3];
  }

  inline public function last():D {
    return this[4];
  }
}

@:native("vim.spell")
extern class Spell {
  public static function check(str:String):Array< Vector3< String, String, Int > >;
}
