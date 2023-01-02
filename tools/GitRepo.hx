package tools;

import tools.Cmd;
import sys.FileSystem;
import tools.Result;

class GitRepo {
  final path:String;
  final repoUrl:String;

  public function new(repoUrl, destinationPath) {
    this.path = destinationPath;
    this.repoUrl = repoUrl;
  }

  static function destinationExists(path):Bool {
    return FileSystem.isDirectory(path) && FileSystem.isDirectory(path) && FileSystem.readDirectory(path).length > 0;

    // return path.exists() && path.isDirectory() && path.readDirectory().length > 0;
  }

  public function toString() {
    return '${this.repoUrl} => ${this.path}';
  }

  public static function clone(repo, dest):Result< GitRepo > {
    if (destinationExists(dest)) {
      Sys.println("Destination path exist, skip repo clone");
      return Ok(new GitRepo(repo, dest));
    }
    final status = executeCommand("git", ["clone", repo, dest, "--single-branch"]);
    return switch (status) {
      case Ok(_): Ok(new GitRepo(repo, dest));
      case Error(err): Error(err);
    }
  }
}
