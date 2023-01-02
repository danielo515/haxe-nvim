package packer;

import vim.Vim;
import lua.Table.create as t;
import plenary.Job;

inline extern function packer_plugins():Null< lua.Table< String, {loaded:Bool, path:String, url:String} > >
  return untyped __lua__("_G.packer_plugins");

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
