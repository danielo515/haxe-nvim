package vim.plugin;

@:autoBuild(vim.plugin.PluginMacro.pluginInterface())
interface VimPlugin {
  /*
    This is an empty interface that is used to attach @:autoBuild
    to classes that implement it.  
    The @:autoBuild macro will generate the required require function to load the plugin safely.
    The implementing class must have a field named `libName`, which will be used 
    in the generated require function.

    Any public variable annotated with `@module` will generate a getter function
    to require that as a submodule of the plugin, also using the `libName` field
    and a safe require function that is guaranteed to not throw.
   */
}
