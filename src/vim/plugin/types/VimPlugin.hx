package vim.plugin.types;

import lua.Lua;

abstract Plugin< T >(T) {
  public function new(library:T) {
    this = library;
  }

  @:from
  public static inline function from< T >(pluginName:String):Plugin< T > {
    final requireResult = Lua.pcall(Lua.require, pluginName);
    if (requireResult.status) {
      return new Plugin(requireResult.value);
    } else {
      return new Plugin(null);
    }
  }
}
