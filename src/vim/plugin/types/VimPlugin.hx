package vim.plugin.types;

import lua.Lua;

abstract Plugin< T >(Null< T >) {
  inline function new(pluginName:String) {
    final requireResult = Lua.pcall(Lua.require, pluginName);
    this = requireResult.value;
  }

  @:from
  public static inline function from< T >(pluginName:String):Plugin< T > {
    return new Plugin(pluginName);
  }

  public inline function map< R >(f:T -> R):Null< R > {
    return if (this == null) null else f(this);
  }

  public inline function call(f:T -> Void):Void {
    if (this != null)
      f(this);
  }
}
