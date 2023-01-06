package vim.types;

enum ArgCompleteEnum {
  Custom(vimFn:String);
  CustomLua(luaRef:String);

  /** file names in argument list */
  ArgList;

  /** autocmd groups */
  Augroup;

  /** buffer names */
  Buffer;

  /** :behave suboptions */
  Behave;

  /** color schemes */
  Color;

  /** Ex command (and arguments) */
  Command;

  /** compilers */
  Compiler;

  /** directory names */
  Dir;

  /** environment variable names */
  Environment;

  /** autocommand events */
  Event;

  /** Vim expression */
  Expression;

  /** file and directory names */
  File;

  /** file and directory names in |'path'| */
  File_in_path;

  /** filetype names |'filetype'| */
  Filetype;

  /** function name */
  Function;

  /** help subjects */
  Help;

  /** highlight groups */
  Highlight;

  /** :history suboptions */
  History;

  /** locale names (as output of locale -a) */
  Locale;

  /** Lua expression */
  Lua;

  /** buffer argument */
  Mapclear;

  /** mapping name */
  Mapping;

  /** menus */
  Menu;

  /** |:messages| suboptions */
  Messages;

  /** options */
  Option;

  /** optional package |pack-add| names */
  Packadd;

  /** Shell command */
  Shellcmd;

  /** |:sign| suboptions */
  Sign;

  /** syntax file names |'syntax'| */
  Syntax;

  /** |:syntime| suboptions */
  Syntime;

  /** tags */
  Tag;

  /** tags, file names are shown when CTRL-D is hit */
  Tag_listfiles;

  /** user names */
  User;

  /** user variables */
  Var;
}

abstract ArgComplete(String) to String {
  private inline function new(arg) {
    this = arg;
  }

  @:from
  public static inline function from(enumValue:ArgCompleteEnum):ArgComplete {
    return switch (enumValue) {
      case Custom(ref): new ArgComplete('custom,$ref');
      case CustomLua(ref): new ArgComplete('customlist,v:lua.$ref');
      case ArgList: new ArgComplete("arglist");
      case Augroup: new ArgComplete("augroup");
      case Buffer: new ArgComplete("buffer");
      case Behave: new ArgComplete("behave");
      case Color: new ArgComplete("color");
      case Command: new ArgComplete("command");
      case Compiler: new ArgComplete("compiler");
      case Dir: new ArgComplete("dir");
      case Environment: new ArgComplete("environment");
      case Event: new ArgComplete("event");
      case Expression: new ArgComplete("expression");
      case File: new ArgComplete("file");
      case File_in_path: new ArgComplete("file_in_path");
      case Filetype: new ArgComplete("filetype");
      case Function: new ArgComplete("function");
      case Help: new ArgComplete("help");
      case Highlight: new ArgComplete("highlight");
      case History: new ArgComplete("history");
      case Locale: new ArgComplete("locale");
      case Lua: new ArgComplete("lua");
      case Mapclear: new ArgComplete("mapclear");
      case Mapping: new ArgComplete("mapping");
      case Menu: new ArgComplete("menu");
      case Messages: new ArgComplete("messages");
      case Option: new ArgComplete("option");
      case Packadd: new ArgComplete("packadd");
      case Shellcmd: new ArgComplete("shellcmd");
      case Sign: new ArgComplete("sign");
      case Syntax: new ArgComplete("syntax");
      case Syntime: new ArgComplete("syntime");
      case Tag: new ArgComplete("tag");
      case Tag_listfiles: new ArgComplete("tag_listfiles");
      case User: new ArgComplete("user");
      case Var: new ArgComplete("var");
    };
  }
}
