package vim.plugin;

import lua.Lua;

inline function load< T >(pluginName:String):Option< T > {
  final requireResult = Lua.pcall(Lua.require, pluginName);
  if (requireResult.status) {
    return Some(requireResult.value);
  } else {
    return None;
  }
}
