import haxe.Json;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroType;
import sys.io.File;

var patches = [
  "nvim_create_augroup" => macro :vim.Vim.Group,
  "nvim_buf_get_keymap" => macro :vim.VimTypes.LuaArray< vim.VimTypes.MapInfo >,
  "nvim_create_user_command.opts" => macro :TableWrapper< {
    desc:String,
    force:Bool
  } >
];

function getLibraryBase() {
  final base = Path.directory(haxe.macro.Context.resolvePath('vim/Vim.hx'));
  return base;
}

function getResPath(filename:String):String {
  return Path.join([getLibraryBase(), '../../res', filename]);
}

macro function generateApi():Void {
  var specs = Json.parse(File.getContent(getResPath('nvim-api.json')));

  Context.defineType({
    pack: ["nvim"],
    name: "API",
    isExtern: true,
    kind: TDClass(),
    #if !dump
    meta: [meta("native", [macro "vim.api"])],
    #end
    fields: [for (f in (specs.functions : Array< FunctionDef >)) {
      {
        name: f.name,
        access: [AStatic, APublic],
        meta: (f.deprecated_since != null) ? [meta('deprecated')] : [],
        kind: FFun({
          args: f.parameters.map(p -> ({
            name: p.name,
            type: resolveType(f.name, p.name, p.type)
          } : FunctionArg)),
          ret: resolveType(f.name, null, f.return_type)
        }),
        pos: (macro null).pos
      }
    }],
    pos: (macro null).pos
  });
}

function resolveType(fun:String, arg:Null< String >, t:String):ComplexType {
  var patch = patches.get(arg == null ? fun : '$fun.$arg');
  if (patch != null)
    return patch;

  return switch (t) {
    case "String": macro :String;
    case "LuaRef": macro :haxe.Constraints.Function;
    case "Window": macro :vim.VimTypes.WindowId;
    case "Client": macro :vim.VimTypes.Client;
    case "Buffer": macro :vim.VimTypes.Buffer;
    case "Integer": macro :Int;
    case "Float": macro :Float;
    case "Tabpage": macro :vim.VimTypes.TabPage;
    case "Dictionary": macro :lua.Table< String, Dynamic >;
    case "Boolean": macro :Bool;
    case "Object": macro :Dynamic;
    case "Array": macro :vim.VimTypes.LuaArray< Dynamic >;
    case "void": macro :Void;

    case t if (StringTools.startsWith(t, "ArrayOf(")):
      final regexArrayArg = ~/ArrayOf\(([a-zA-Z]+),?/i;
      regexArrayArg.match(t);
      var itemType = resolveType(fun, (arg == null ? "" : arg) + "[]", regexArrayArg.matched(1));
      macro :vim.VimTypes.LuaArray< $itemType >;

    case _:
      Context.warning('Cannot resolve type $t', (macro null).pos);
      macro :Dynamic;
  };
}

function meta(m:String, ?params:Array< Expr >):MetadataEntry {
  return {name: ':$m', params: params, pos: (macro null).pos};
}

abstract ParamDef(Array< String >) {
  public var type(get, never):String;

  function get_type():String
    return this[0];

  public var name(get, never):String;

  function get_name():String
    return this[1];
}

typedef FunctionDef = {
  final name:String;
  final method:Bool;
  final parameters:Array< ParamDef >;
  final return_type:String;
  final since:Int;
  @:optional final deprecated_since:Int;
}

typedef FunctionWithDocs = {
  > FunctionDef,
  final parameters:Array< ParamDef >;
  final docs:Array< String >;
}

// Thanks again @rudy
function parseTypeFromStr(typeString:String) {
  try {
    return switch (haxe.macro.Context.parse('(null:$typeString)', (macro null).pos).expr) {
      case EParenthesis({expr: ECheckType(_, ct)}):
        ct;

      case _: throw 'Unable to parse: $typeString';
    }
  }
  catch (e) {
    // TODO;; enable this
    // Context.warning('bad type string: `$typeString`', (macro null).pos);
    throw 'Unable to parse: $typeString';
  }
}

macro function attachApi(namespace:String):Array< Field > {
  var fields = Context.getBuildFields();
  final existingFields = fields.map(f -> f.name);
  var specs:Array< FunctionWithDocs > = Json.parse(File.getContent(getResPath('$namespace.json')));
  specs = specs.filter(x -> !existingFields.contains(x.name) && x.name != "");

  final failures = [];

  final newFields:Array< Field > = [for (f in (specs)) {
    try {
      {
        name: f.name,
        doc: f.docs.join("\n"),
        meta: [],
        access: [AStatic, APublic],
        kind: FFun({
          args: f.parameters.map(p -> ({
            name: p.name,
            type: parseTypeFromStr(p.type)
          } : FunctionArg)),
          ret: parseTypeFromStr(f.return_type)
        }),
        pos: Context.currentPos()
      }
    }
    catch (error:String) {
      failures.push({block: f, error: error});
      continue;
    }
  }];
  if (failures.length > 0) {
    final handle = File.write(Path.join(['dump', namespace + '-error.json']), false);
    handle.writeString(Json.stringify(failures, null, " "));
    handle.close();
  }
  return fields.concat(newFields);
}
