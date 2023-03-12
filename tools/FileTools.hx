package tools;

import sys.io.File;
import sys.io.Process;
import tools.Result;
import haxe.io.Path;

/**
  Given a path that can be found by the Haxe compiler, return the directory
  that contains it.
  This is useful to get the correct paths within a library.
 */
function getDirFromPackagePath(path) {
  final base = Path.directory(haxe.macro.Context.resolvePath(path));
  return base;
}

function getNvimRuntimePath() {
  return switch (Cmd.executeCommand("nvim", [
    "--clean",
    "--headless",
    "--cmd",
    "echo $VIMRUNTIME | qa "
  ], true)) {
    case Error(error):
      Sys.println("Failed to get VIMRUNTIME");
      Sys.println(error);
      Error(error);
    case ok: ok;
  }
}

function writeTextFile(outputPath:String, data:String) {
  final handle = File.write(outputPath, false);
  handle.writeString(data);
  handle.close();
}

function getResPath(filename:String):String {
  return Path.join([
    getDirFromPackagePath('tools/FileTools.hx'),
    '../res',
    filename
  ]);
}
