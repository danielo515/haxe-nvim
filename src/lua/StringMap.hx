package lua;

class StringMap< T > {
	private var h:lua.Table< String, T >;

	static var tnull:Dynamic = lua.Table.create();

	public function new():Void {
		h = lua.Table.create();
	}

	public function set(key:String, value:T):Void {
		if (value == null) {
			h[untyped key] = tnull;
		} else {
			h[untyped key] = value;
		}
	}

	public function get(key:String):Null< T > {
		var ret = h[untyped key];
		if (ret == tnull) {
			return null;
		}
		return ret;
	}

	public inline function exists(key:String):Bool {
		return h[untyped key] != null;
	}
}
