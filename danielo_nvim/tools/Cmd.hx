package tools;

import haxe.io.Path;
import sys.io.Process;

function executeCommand(cmd, args, readStder = false):Result< String > {
  final res = new Process(cmd, args);
  return switch (res.exitCode(true)) {
    case 0:
      Ok(!readStder ? res.stdout.readAll().toString() : res.stderr.readAll().toString());
    case _:
      Error(res.stderr.readLine());
  }
}

// function getHomeFolder() {
//   return Sys.getEnv(if (Sys.systemName() == "Windows")"UserProfile" else "HOME");
// }

function getHomeFolder():String {
  return switch (Sys.systemName()) {
    case "Windows":
      Sys.getEnv("USERPROFILE");
    default:
      var home = Sys.getEnv("XDG_CONFIG_HOME");
      if (home == null)Sys.getEnv("HOME"); else home;
  }
}

/*
  Returns a temporary folder to be used.
  It tries to folow the XDG spec, and if not
  tries to use platform specific folders reading env variables.
  If that is not available, fallback to the user home folder
  with the provided namespace.
 */
function getTempFolderPath(namespace:String):String {
  var temp = Sys.getEnv("XDG_RUNTIME_DIR");
  if (temp != null) {
    return temp;
  }
  final fallback = Path.join([getHomeFolder(), namespace]);
  return switch (Sys.systemName()) {
    case "Windows":
      final tmp = Sys.getEnv("TEMP");
      if (tmp != null)tmp; else Sys.getEnv("TMP");
    case "Mac" | "Linux":
      switch (executeCommand("mktemp", ["-d", "-t", namespace])) {
        case Ok(path): path;
        case Error(_): fallback;
      }
    default: fallback;
  }
}
