package plenary;

import vim.VimTypes.LuaArray;
import lua.Table;

typedef Job_opts = {
	final command:String;
	final args:LuaArray< String >;
	final ?cwd:Null< String >;
	final ?on_stdout:(Null< String >, String) -> Void;
	final ?on_stderr:(String, Int) -> Void;
}

// @:build(TableBuilder.build())

@:luaRequire("plenary.job")
extern class Job {
	private static inline function create(args:Table< String, Dynamic >):Job {
		return untyped __lua__("{0}:new({1})", Job, args);
	}
	static inline function make(jobargs:Job_opts):Job {
		return create(Table.create(jobargs));
	}
	function start():Void;
	function sync():Table< Int, String >;
}
