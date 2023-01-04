package vim.plugin;

enum LibraryState {
  Required;
  Installed;
}

private final libraries:Map< String, LibraryState > = new Map();

function registerLibrary(libraryName:String, ?commit:Null< String >) {
  if (!libraries.exists(libraryName))
    libraries.set(libraryName, Required);
}
