package lua;

@:expose
class Pair< A > {
	@:pure public static inline function make< A >(a:A, b:A):Pair< A > {
		return untyped {
			__lua__("{ {0}, {1} }", a, b);
		}
	}
}
