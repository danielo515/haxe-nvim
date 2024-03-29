import vim.Api;
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

function createSiblingFile():Void {
  final path = Vim.expand(ExpandString.plus(CurentFile, Head));
  final currentFileName = vim.Fn.expand(ExpandString.plus(CurentFile, Tail));
  vim.Ui.input({prompt: 'newFileName'}, (filename) -> {
    Vim.cmd("e " + path + "/" + filename);
  });
}

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

// Derive looks like this
// #[derive(Debug, Clone)]
function add_missing_derive(toAdd:String) {
  final lines = Api.nvim_buf_get_lines(CurrentBuffer, 0, -1, false).toArray();
  final deriveLines = lines.filter(x -> x.contains("#[derive("));
  final derives = [for (line in deriveLines) {
    final content = line.split("derive(")[1].split(")")[0];
    final elements = content.split(",").map(x -> x.trim());
    {
      "line": line,
      "elements": elements
    };
  }];
  trace(derives);
  final newDeriveList = derives.filter(x -> !x.elements.contains(toAdd)).map((x) -> {
    {
      "line": x.line,
      "elements": x.elements.concat([toAdd])
    };
  });
  trace(newDeriveList);
  final newLines = lines.map(x -> {
    final match = newDeriveList.find(y -> y.line == x);
    if (match != null) {
      final newDerive = "#[derive(" + match.elements.join(", ") + ")]";
      trace(newDerive);
      return newDerive;
    } else {
      return x;
    }
  });
  Api.nvim_buf_set_lines(CurrentBuffer, 0, -1, false, Table.fromArray(newLines));
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
    args -> copyGhUrl(switch (args.range) {
      case 1: ':${args.line1}';
      case 2: ':${args.line1}-${args.line2}';
      case _: "";
    })
  );

  command(
    "CopyMessagesToClipboard",
    "Copy the n number of messages to clipboard",
    (args) -> copy_messages_to_clipboard(args.args),
    ExactlyOne
  );
  command(
    "AddMissingDerive",
    "Add a missing derive to the current file",
    (args) -> add_missing_derive(args.args),
    ExactlyOne

  );
  command("RustPrettier", "Format with prettier", (_) -> Vim.cmd("!prettier % -w"), None);
  command(
    "CreateSiblingFile",
    "Create a file next to the current one",
    (_) -> createSiblingFile(),
    None
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
  command("Scratch", "creates a scratch buffer", (_) -> {
    final buffer = Api.nvim_create_buf(false, true);
    Api.nvim_win_set_buf(CurrentWindow, buffer);
  });
  // final keymaps = vim.Api.nvim_buf_get_keymap(CurrentBuffer, "n");
  // Vim.print(keymaps.map(x -> '${x.lhs} -> ${x.rhs} ${x.desc}'));
  vim.Keymap.set(Normal, "tl", nexTab, {desc: "Go to next tab", silent: true, expr: false});
  vim.Keymap.set(Command, "<C-A>", "<Home>", {desc: "Home in cmd", silent: true, expr: false});
  vim.Keymap.set(
    Normal,
    "<c-m-f>",
    ":FzfLua lines<cr>",
    {desc: "Search in open files", silent: true, expr: false}
  );
  vim.Keymap.set(
    Normal,
    "<leader>sl",
    ":FzfLua lines<cr>",
    {desc: "Search [l]ines in open files", silent: true, expr: false}
  );
  vim.Keymap.set(
    Normal,
    "<C-s>",
    ":%s/\\v",
    {desc: "Search and replace whole file", silent: true, expr: false}
  );
  // nmap("<M-Tab>", ":b#<cr>", "Alternate file", true)
  vim.Keymap.set(
    Normal,
    "<M-Tab>",
    ":b#<cr>",
    {desc: "Alternate file", silent: true, expr: false}
  );
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
  main();
  Vim.print("ran setup");
}
