package vim;

import haxe.Constraints.Function;
import vim.VimTypes;

@:native("vim.lsp")
@:build(ApiGen.attachApi("lsp"))
extern class Lsp {}

@:native("vim.lsp.buf")
@:build(ApiGen.attachApi("lsp_buf"))
extern class LspBuf {
  public static function list_workspace_folders():LuaArray< String >;
  public static function format(?opts:TableWrapper< {timeout_ms:Int, bufnr:Buffer, filter:Dynamic -> Bool} >):LuaArray< String >;
}

@:native("vim.lsp.protocol")
extern class Protocol {
  static function make_client_capabilities():Dynamic;
}
