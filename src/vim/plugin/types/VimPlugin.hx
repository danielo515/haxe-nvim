package vim.plugin.types;

import lua.Lua;

abstract VimPlugin< T >(Null< T >) {
  inline function new(pluginName:String) {
    final requireResult = Lua.pcall(Lua.require, pluginName);
    if (requireResult.status)
      this = requireResult.value;
    else this = null;
  }

  @:from
  public static inline function from< T >(pluginName:String):VimPlugin< T > {
    return new VimPlugin(pluginName);
  }

  public inline function map< R >(f:T -> R):Null< R > {
    return if (this == null) null else f(this);
  }

  public inline function call(f:T -> Void):Void {
    if (this != null)
      f(this);
  }
}
