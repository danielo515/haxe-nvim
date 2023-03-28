package vim.plugin;

using haxe.macro.TypeTools;

import haxe.macro.Context;
import haxe.macro.Expr;

class PluginMacro {
  /**
    helper to transform the declaration annotated with @module
    into a getter that calls Vimx.require with the correct path
    based on the library name.
    e.g.:
    ```haxe 
    // given
     @module var submodule:SomeType;
    // becomes
    public static var submodule(get, null):Null< SomeType >;
    inline static public function get_submodule():Null< SomeType > {
      return vim.Vimx.require("mylib.submodule");
    }
    ```
  **/
  static public function makeModule(libName, name, typeName):Array< Field > {
    final returnType = macro :$typeName;
    final getter = 'get_$name';
    final requirePath = libName + '.' + name;
    final built = macro class {
      public static var $name(get, null):Null< $returnType >;

      inline static public function $getter():Null< $returnType > {
        return vim.Vimx.require($v{requirePath});
      }
    };
    return built.fields;
  }

  /**
    For docs about this take a look at the VimPlugin interface
   */
  macro static public function pluginInterface():Array< Field > {
    final fields = Context.getBuildFields();
    final localType = Context.getLocalType().toComplexType();
    final returnType = macro :$localType;
    var libName = null;
    return fields.flatMap(field -> switch field {
      case {name: "libName", kind: FVar(_, {expr: EConst(CString(val, _))})}:
        final built = macro class X {
          inline static public function require():Null< $returnType > {
            return vim.Vimx.require($v{val});
          }
        };
        libName = val;
        built.fields;

      case {name: name, meta: [{name: "module"}], kind: FVar(t, e)}:
        if (libName == null) {
          Context.error("libName must be defined before any @module", field.pos);
        }
        makeModule(libName, name, t);

      case _: [field];
    });
  }
}
