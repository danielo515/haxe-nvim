class Test {
	/**
	 *  Returns `value` if it is not `null`. Otherwise returns `defaultValue`.
	 */
	static public function or< T >(v:Null< T >, fallback:T):T {
		return v != null ? v : fallback;
	}
}
