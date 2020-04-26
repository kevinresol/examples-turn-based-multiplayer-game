package model;

abstract Transition(Void->Void) from Void->Void to Void->Void {
	public inline function new(f) {
		this = f;
	}

	public inline function apply() {
		this();
	}

	public function chain(other:Transition) {
		return new Transition(() -> {
			apply();
			other.apply();
		});
	}
}
