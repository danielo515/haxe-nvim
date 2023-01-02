package vim;

import vim.Api;
import lua.StringMap;
import vim.VimTypes;
import haxe.Constraints.Function;

using Safety;

@:expose("vim")
class Vimx {
  public static final autogroups:StringMap< Group > = new StringMap();

  /**
    Creates a new autocommand and associates it to the given group name.
    If the group has not been registered before, it gets created and cached
    so future commands with the same group name will re-use the same group.
    Note that existing commands on the group created outside of this function
    are not checked for existence.
   */
  static public function autocmd(
    groupName:String,
    events:LuaArray< VimEvent >,
    pattern:String,
    ?description:String,
    cb:Function
  ) {
    var group:Group;
    switch (autogroups.get(groupName)) {
      case null:
        group = Api.nvim_create_augroup(groupName, {clear: true});
        autogroups.set(groupName, group);
      case x:
        group = x;
    };
    Api.nvim_create_autocmd(
      events,
      new AutoCmdOpts(pattern, cb, group, description.or('$groupName:[$pattern]'))
    );
  }

  /**
    Copies the given string to the system clipboard
   */
  public static function copyToClipboard(str:String) {
    final cmd = 'let @* = "$str"';
    Vim.cmd(cmd);
    Vim.notify("Copied to clipboard", "info");
  }
}
