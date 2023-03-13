import vim.Vimx;
import plenary.Job;
import vim.Vim;
import vim.VimTypes;
import lua.Table.create as t;

using lua.NativeStringTools;
using lua.Table;
using vim.TableTools;
using Lambda;
using Test;

inline function command(name, description, fn, ?nargs) {
  vim.Api.nvim_create_user_command(name, fn, {
    desc: description,
    force: true,
    nargs: nargs,
    complete: null,
    bang: false,
    range: Yes,
  });
}

function main() {
  vim.Api.create_user_command_completion(
    "HaxeCmd",
    (args) -> {
      Vim.print(args);
      final spellRes = Spell.check("Hello bru! Hau are you?");
      Vim.print(spellRes[1].first());
      vim.Ui.select(t(["a"]), {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
    },
    CustomLua("require'packer'.plugin_complete"),
    {
      desc: "Testing from haxe",
      force: true,
      bang: true,
      range: WholeFile,
    }
  );

  vim.Api.nvim_create_user_command_complete_cb("HaxeCmdCompletion", (args) -> {
    Vim.print(args);
    final spellRes = Spell.check("Hello bru! Hau are you?");
    Vim.print(spellRes[1].first());
    vim.Ui.select(t(["a"]), {prompt: "Pick one sexy option"}, (choice, _) -> Vim.print(choice));
  }, {
    desc: "Testing from haxe for completion callback",
    force: true,
    bang: true,
    nargs: Any,
    range: WholeFile,
    complete: (lead:String, full:String, x:Int) -> {
      Vim.print(lead, full, x);
      return t(["afa", "bea", lead + "bro"]);
    }
  });

  Vimx.autocmd('HaxeEvent', [BufWritePost], "*.hx", "Created from haxe", () -> {
    var filename = Vim.expand(ExpandString.plus(CurentFile, FullPath));
    Vim.print('Hello from axe', filename);
    return true;
  });

  command(
    "OpenInGh",
    "Open the current file in github",
    args -> openInGh(switch (args.range) {
      case 1: ':${args.line1}';
      case 2: ':${args.line1}-${args.line2}';
      case _: "";
    })
  );
  command(
    "CopyGhUrl",
    "Copy current file github URL",
    args -> copyGhUrl(args.count > 0 ? ':${args.count}' : "")
  );

  command(
    "CopyMessagesToClipboard",
    "Copy the n number of messages to clipboard",
    (args) -> copy_messages_to_clipboard(args.args),
    ExactlyOne
  );
  command(
    "GetPluginVersion",
    "Gets the git version of a installed packer plugin",
    (args) -> {
      final version = packer.Packer.get_plugin_version(args.args);
      Vim.print(version);
      Vimx.copyToClipboard(version);
    },
    ExactlyOne
  );
  // final keymaps = vim.Api.nvim_buf_get_keymap(CurrentBuffer, "n");
  // Vim.print(keymaps.map(x -> '${x.lhs} -> ${x.rhs} ${x.desc}'));
  vim.Keymap.set(Normal, "tl", nexTab, {desc: "Go to next tab", silent: true, expr: false});
  // show the effects of a search / replace in a live preview window
  Vim.o.inccommand = "split";
}

function runGh(args):Null< lua.Table< Int, String > > {
  if (vim.Fn.executable("gh") != 1)
    return null;

  final job = Job.make({
    command: "gh",
    args: args,
    on_stderr: (args, return_val) -> {
      Vim.print("Job got stderr", args, return_val);
    }
  });
  return job.sync();
}

function openInGh(?line) {
  final currentFile = vim.Fn.expand(CurentFile);
  final curentBranch = get_branch();
  runGh([
    "browse",
    currentFile + line,
    "--branch",
    curentBranch[1]
  ]);
}

function get_branch() {
  var args = lua.Table.create(["rev-parse", "--abbrev-ref", "HEAD"]);
  final job = Job.make({
    command: "git",
    args: args,
    on_stderr: (args, return_val) -> {
      Vim.print("Something may have  failed", args, return_val);
    }
  });
  return job.sync();
}

function copy_messages_to_clipboard(number:String) {
  final cmd = "let @* = execute('%smessages')".format(number.or(""));
  Vim.cmd(cmd);
  Vim.notify('$number :messages copied to the clipboard', "info");
}

function nexTab() {
  final pages = vim.Api.nvim_list_tabpages();
  final currentTab = vim.Api.nvim_get_current_tabpage();
  final nextT = pages.findNext(id -> id == currentTab);
  vim.Api.nvim_set_current_tabpage(nextT.or(pages[1]));
}

function copyGhUrl(?line) {
  final currentFile = vim.Fn.expand(new ExpandString(CurentFile) + RelativePath);
  final curentBranch = get_branch();
  var lines = runGh([
    "browse",
    currentFile + line,
    "--no-browser",
    "--branch",
    curentBranch[1]
  ]);
  switch (lines) {
    case null:
      Vim.print("No URL");
    case _:
      Vim.print(lines[1]);
      Vimx.copyToClipboard(lines[1]);
  }
}

@:expose("setup")
function setup() {
  Vim.print("ran setup");
}
