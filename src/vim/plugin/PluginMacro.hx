package vim.plugin;

using haxe.macro.TypeTools;

import haxe.macro.Context;
import haxe.macro.Expr;

class PluginMacro {
  macro static public function pluginInterface():Array< Field > {
    final fields = Context.getBuildFields();
    final localType = Context.getLocalType().toComplexType();
    final returnType = macro :$localType;
    final newFields = [for (field in fields) {
      switch field {
        case {name: "libName", kind: FVar(_, {expr: EConst(CString(val, _))})}:
          final built = macro class X {
            inline static public function require():Null< $returnType > {
              final module = lua.Lua.pcall(lua.Lua.require, $v{val});
              final value = if (module.status) {
                module.value;
              } else {
                null;
              };
              return value;
            }
          };
          built.fields[0];

        case _:
          continue;
      }
    }];
    if (newFields.length == 0) {
      Context.error("No libName field found in plugin interface", Context.currentPos());
    }
    return fields.concat(newFields);
  }
}
