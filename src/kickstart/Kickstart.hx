package kickstart;

import vim.Vimx;
import kickstart.LspConfig;
import vim.Lsp;
import vim.Vim;
import vim.VimTypes;
import lua.Table.create as t;

@:luaRequire('lualine')
extern class Lualine {
  static function setup(config:TableWrapper< {
    options:{
      icons_enabled:Bool,
      theme:String,
      component_separators:String,
      section_separators:String,
    }
  } >):Void;
}

@:luaRequire('indent_blankline')
extern class IndentBlankline {
  static function setup(config:lua.Table< String, Dynamic >):Void;
}

// typedef SignDefinition = TableWrapper< {text:String} >

@:luaRequire('gitsigns')
extern class Gitsigns {
  static function setup(config:TableWrapper< {
    signs:{
      add:{text:String},
      change:{text:String},
      delete:{text:String},
      topdelete:{text:String},
      changedelete:{text:String},
    }
  } >):Void;
}

@:luaRequire('Comment')
extern class Comment {
  static function setup():Void;
}

@:luaRequire('neodev')
extern class Neodev {
  static function setup():Void;
}

@:luaRequire('mason')
extern class Mason {
  static function setup():Void;
}

@:luaRequire('fidget')
extern class Fidget {
  static function setup():Void;
}

@:luaRequire('cmp_nvim_lsp')
extern class Cmp_nvim_lsp {
  static function default_capabilities(opts:Dynamic):Dynamic;
}

@:luaRequire('mason-lspconfig')
extern class MasonLspConfig {
  static function setup(opts:TableWrapper< {ensure_installed:Array< String >} >):Void;
  static function setup_handlers(handlers:LuaArray< (name:String) -> Void >):Void;
}

@:luaRequire('luasnip')
extern class Luasnip {
  static function lsp_expand(args:Dynamic):Void;
  static function expand_or_jumpable():Bool;
  static function expand_or_jump():Void;
  static function jumpable(?direction:Int):Bool;
  static function jump(?direction:Int):Void;
}

function keymaps() {
  Keymap.set(
    t([Normal, Visual]),
    '<Space>',
    '<Nop>',
    {desc: 'do nothing', silent: true, expr: false}
  );
  Keymap.set(
    t([Normal]),
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    {desc: 'up when word-wrap', silent: true, expr: true}
  );
  Keymap.set(
    t([Normal]),
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    {desc: 'down when word-wrap', silent: true, expr: true}
  );
}

// LSP settings.
//  This function gets run when an LSP connects to a particular buffer.
function onAttach(x:Dynamic, bufnr:Buffer) {
  function nmap(keys, func, desc) {
    Keymap.setBuf(Normal, keys, func, {buffer: bufnr, desc: 'LSP: $desc'});
  }
  nmap('<leader>rn', LspBuf.rename, '[R]e[n]ame');
  nmap('<leader>ca', LspBuf.code_action, '[C]ode [A]ction');

  nmap('gd', LspBuf.definition, '[G]oto [D]efinition');
  // nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences');
  nmap('gI', LspBuf.implementation, '[G]oto [I]mplementation');
  nmap('<leader>D', LspBuf.type_definition, 'Type [D]efinition');
  // nmap(
  //   '<leader>ds',
  //   require('telescope.builtin').lsp_document_symbols,
  //   '[D]ocument [S]ymbols'
  // );
  // nmap(
  //   '<leader>ws',
  //   require('telescope.builtin').lsp_dynamic_workspace_symbols,
  //   '[W]orkspace [S]ymbols'
  // ); // See `:help K` for why this keymap

  nmap('K', LspBuf.hover, 'Hover Documentation');
  nmap('<C-k>', LspBuf.signature_help, 'Signature Documentation'); // Lesser used LSP functionality

  nmap('gD', LspBuf.declaration, '[G]oto [D]eclaration');
  nmap('<leader>wa', LspBuf.add_workspace_folder, '[W]orkspace [A]dd Folder');
  nmap('<leader>wr', LspBuf.remove_workspace_folder, '[W]orkspace [R]emove Folder');
  nmap(
    '<leader>wl',
    () -> Vim.print(LspBuf.list_workspace_folders()),
    '[W]orkspace [L]ist Folders'
  ); // Create a command `:Format` local to the LSP buffer

  vim.Api.nvim_buf_create_user_command(bufnr, 'Format', (_) -> LspBuf.format(), {
    desc: 'Format current buffer with LSP',
    force: true,
    nargs: None,
    bang: false,
    range: No,
  });
}

/**
  Port to Haxe of https://github.com/nvim-lua/kickstart.nvim
 */
function main() {
  Vimx.autocmd(
    "Kickstart",
    t([BufWritePost]),
    Fn.expand(MYVIMRC),
    "Reload the config",
    () -> Vim.cmd("source <afile> | PackerCompile")
  );
  Vimx.autocmd(
    "Kickstart-yank",
    [TextYankPost],
    "*",
    "Highlight on yank",
    kickstart.Untyped.higlightOnYank
  );
  Vim.cmd("colorscheme onedark");
  // -- Vim options
  Vim.o.hlsearch = false;
  Vim.o.mouse = 'a';
  Vim.o.breakindent = true;
  Vim.o.undofile = true;

  keymaps();
  // -- Set lualine as statusline
  // -- See `:help lualine.txt`
  Lualine.setup({
    options: {
      icons_enabled: true,
      theme: 'onedark',
      component_separators: '|',
      section_separators: '',
    },
  });

  Comment.setup();

  // -- See `:help indent_blankline.txt`
  IndentBlankline.setup(t({
    char: '┊',
    show_trailing_blankline_indent: false,
  }));

  // -- See `:help gitsigns.txt`
  Gitsigns.setup({
    signs: {
      add: {
        text: '+'
      },
      change: {
        text: '~'
      },
      delete: {
        text: '_'
      },
      topdelete: {
        text: '‾'
      },
      changedelete: {
        text: '~'
      },
    },
  });

  final capabilities = Cmp_nvim_lsp.default_capabilities(vim.Lsp.Protocol.make_client_capabilities());

  Neodev.setup();
  Mason.setup();
  Fidget.setup();
  kickstart.Cmp.configure();
  MasonLspConfig.setup_handlers(t([server_name -> {
    switch (server_name) {
      case 'sumneko_lua': Lspconfig.sumneko_lua.setup({
          capabilities: capabilities,
          on_attach: onAttach,
          settings: t({
            lua: t({
              workspace: t({checkThirdParty: false}),
              telemetry: t({enable: false}),
            })
          })
        });
      case 'jsonls': Lspconfig.jsonls.setup({
          capabilities: capabilities,
          on_attach: onAttach,
          settings: t({
            json: t({
              schemas: t([{
                description: "Haxe format schema",
                fileMatch: t(["hxformat.json"]),
                name: "hxformat.schema.json",
                url: "https://raw.githubusercontent.com/vshaxe/vshaxe/master/schemas/hxformat.schema.json",
              }])
            })
          })
        });
      case _: Vim.print('Ignoring $server_name');
    }
  }]));
}
