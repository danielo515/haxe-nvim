package vim;

using Safety;

import vim.VimTypes;
import haxe.Constraints.Function;
import lua.Table;

typedef CommandCallbackArgs = {
  final args:String;
  final fargs:Table< String, String >;
  final bang:Bool;
  final line1:Int;
  final line2:Int;
  final count:Int;
  final reg:String;
  final mods:String;
}

typedef UserCommandOpts = TableWrapper< {
  desc:String,
  force:Bool,
  ?nargs:Nargs,
  ?bang:Bool,
  // ?range:CmdRange,
} >

abstract AutoCmdOpts(Table< String, Dynamic >) {
  public inline function new(
    pattern:String,
    cb:FunctionOrString,
    group:Group,
    description:String,
    once = false,
    nested = false
  ) {
    this = Table.create(null, {
      pattern: pattern,
      group: group,
      desc: description,
      once: once,
      nested: nested,
    });
    switch (cb) {
      case Cb(f):
        this.callback = f;
      case Str(cmd):
        this.command = cmd;
    }
  }
}

@:native("vim.api")
@:build(ApiGen.attachApi("api"))
extern class Api {
  /**
    Returns a list of available tabpages
   */
  static function nvim_list_tabpages():LuaArray< Tabpage >;

  static function nvim_create_augroup(group:String, opts:GroupOpts):Group;
  static function nvim_create_autocmd(event:LuaArray< VimEvent >, opts:AutoCmdOpts):Int;
  static function nvim_create_user_command(
    command_name:String,
    command:LuaObj< CommandCallbackArgs > -> Void,
    opts:TableWrapper< {
      desc:String,
      force:Bool,
      ?complete:ArgComplete,
      ?nargs:Nargs,
      ?bang:Bool,
      ?range:CmdRange,
    } >
  ):Void;

  /**
    Same as create user command, but this is specifically typed
    for completion callbacks.
    Completion callback should take the following arguments:
      ArgLead, CmdLine, CursorPos
      Where:
      ArgLead: The current value of the argument being completed
      CmdLine: The full command line text
      CursorPos: The current cursor position in the command line
   */
  @:native('nvim_create_user_command')
  static function nvim_create_user_command_complete_cb(
    command_name:String,
    command:LuaObj< CommandCallbackArgs > -> Void,
    opts:TableWrapper< {
      desc:String,
      force:Bool,
      complete:(String, String, Int) -> lua.Table< Int, String >,
      nargs:Nargs,
      ?bang:Bool,
      ?range:CmdRange,
    } >
  ):Void;

  static inline function create_user_command_completion(
    command_name:String,
    command:LuaObj< CommandCallbackArgs > -> Void,
    complete:ArgComplete,
    opts:{
      desc:String,
      force:Bool,
      ?bang:Bool,
      ?range:CmdRange,
    }
  ):Void {
    nvim_create_user_command(command_name, command, {
      desc: opts.desc,
      force: true,
      complete: complete,
      nargs: ExactlyOne,
      bang: opts.bang,
      range: opts.range
    });
  };
  static function nvim_buf_create_user_command(
    bufnr:Buffer,
    command_name:String,
    command:LuaObj< CommandCallbackArgs > -> Void,
    opts:TableWrapper< {
      desc:String,
      force:Bool,
      ?nargs:Nargs,
      ?bang:Bool,
      ?range:CmdRange,
    } >
  ):Void;
}
