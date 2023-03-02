package packer;

import vim.VimTypes.LuaArray;
import vim.Vim;
import lua.Table.create as t;
import plenary.Job;

/**
  PluginSpec type reference:
  {
  'myusername/example',        -- The plugin location string
  -- The following keys are all optional
  disable = boolean,           -- Mark a plugin as inactive
  as = string,                 -- Specifies an alias under which to install the plugin
  installer = function,        -- Specifies custom installer. See "custom installers" below.
  updater = function,          -- Specifies custom updater. See "custom installers" below.
  after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
  rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
  opt = boolean,               -- Manually marks a plugin as optional.
  bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
  branch = string,             -- Specifies a git branch to use
  tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
  commit = string,             -- Specifies a git commit to use
  lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
  run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
  requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
  rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
  config = string or function, -- Specifies code to run after this plugin is loaded.
  -- The setup key implies opt = true
  setup = string or function,  -- Specifies code to run before this plugin is loaded. The code is ran even if
                               -- the plugin is waiting for other conditions (ft, cond...) to be met.
  -- The following keys all imply lazy-loading and imply opt = true
  cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
  ft = string or list,         -- Specifies filetypes which load this plugin.
  keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
  event = string or list,      -- Specifies autocommand events which load this plugin.
  fn = string or list          -- Specifies functions which load this plugin.
  cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
  module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
                               -- with one of these module names, the plugin will be loaded.
  module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When
                               -- requiring a string which matches one of these patterns, the plugin will be loaded.
  }
 */
// PluginSpec translated to haxe
typedef PluginSpec = {
  @idx(1)
  final name:String;
  final ?disable:Bool;
  final ?as:String;
  final ?installer:Void -> Void;
  final ?updater:Void -> Void;
  final ?after:String;
  final ?rtp:String;
  final ?opt:Bool;
  final ?bufread:Bool;
  final ?branch:String;
  final ?tag:String;
  final ?commit:String;
  final ?lock:Bool;
  final ?run:String;
  final ?requires:LuaArray< String >;
  final ?rocks:String;
  final ?config:Void -> Void;
  final ?setup:String;
  final ?cmd:String;
  final ?ft:String;
  final ?keys:String;
  final ?event:LuaArray< String >;
  final ?fn:String;
  final ?cond:String;
  final ?module:String;
  final ?module_pattern:String;
}

inline extern function packer_plugins():Null< lua.Table< String, {loaded:Bool, path:String, url:String} > >
  return untyped __lua__("_G.packer_plugins");

/**
  Returns the git commit hash of the plugin.
  It only looks for plugins that are part of the packer plugin list.
  If the list is not available, it returns "unknown".
 */
function get_plugin_version(name:String):String {
  return if (packer_plugins() != null) {
    final path = packer_plugins()[cast name].path;
    final job = Job.make({
      command: "git",
      cwd: path,
      args: t(['rev-parse', '--short', 'HEAD']),
      on_stderr: (args, return_val) -> {
        Vim.print("Job got stderr", args, return_val);
      }
    });
    job.sync()[1];
  } else {
    "unknown";
  }
}

/**
  Checks if packer is installed and installs it if not.
  Returns true if packer was not installed and the installation was performed.
  You should use this information to decide if you need to run sync()
 */
function ensureInstalled():Bool {
  final install_path = Fn.stdpath("data") + "/site/pack/packer/start/packer.nvim";
  return if (vim.Fn.empty(vim.Fn.glob(install_path, null)) > 0) {
    vim.Fn.system(t([
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path
    ]), null);
    Vim.cmd("packadd packer.nvim");
    return true;
  } else {
    return false;
  };
}

abstract Plugin(PluginSpec) {
  @:from
  public static inline function from(spec:PluginSpec):Plugin {
    return untyped __lua__(
      "{ 
        {0}, 
        disable={1},
        as={2},
        installer={3},
        updater={4},
        after={5},
        rtp={6},
        opt={7},
        bufread={8},
        branch={9},
        tag={10},
        commit={11},
        lock={12},
        run={13},
        requires={14},
        rocks={15},
        config={16},
        setup={17},
        cmd={18},
        ft={19},
        keys={20},
        event={21},
        fn={22},
        cond={23},
        module={24},
        module_pattern={25}
      }",
      spec.name,
      spec.disable,
      spec.as,
      spec.installer,
      spec.updater,
      spec.after,
      spec.rtp,
      spec.opt,
      spec.bufread,
      spec.branch,
      spec.tag,
      spec.commit,
      spec.lock,
      spec.run,
      spec.requires,
      spec.rocks,
      spec.config,
      spec.setup,
      spec.cmd,
      spec.ft,
      spec.keys,
      spec.event,
      spec.fn,
      spec.cond,
      spec.module,
      spec.module_pattern
    );
  };
}

extern class Packer {
  @:luaDotMethod
  function startup(use:(Plugin -> Void) -> Void):Void;
  @:luaDotMethod
  function sync():Void;

  /**
    Does the packer initlization and returns true if packer was not installed and the installation was performed.
    Takes an array of plugin specs to install.
   */
  inline static function init(plugins:Array< Plugin >):Bool {
    final is_bootstrap = ensureInstalled();
    final packer:Packer = lua.Lua.require("packer");
    packer.startup((use) -> {
      for (plugin in plugins) {
        use(plugin);
      }
    });
    if (is_bootstrap) {
      packer.sync();
    }
    return is_bootstrap;
  }
}
