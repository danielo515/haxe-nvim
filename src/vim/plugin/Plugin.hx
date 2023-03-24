package vim.plugin;

@:autoBuild(vim.plugin.PluginMacro.pluginInterface())
interface VimPlugin {
  /*
    This is an empty interface that is used to attach the @:autoBuild
    to classes that implement it.  The @:autoBuild macro will generate
    the required require code to load the plugin safely.
    The implementing class must have a field named libName, which will be used 
    in the generated require function.
   */
}
