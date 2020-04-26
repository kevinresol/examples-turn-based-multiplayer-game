package model;

class Player implements Model {
	static var ids = 0;

	@:constant var commands:Signal<Command>;
	@:constant var id:Int = ids++;
	@:constant var name:String;
	@:observable var position:Int = 0;

	@:transition
	private function patch(v)
		return v;

	public function walk():Promise<Transition> {
		return new Transition(patch.bind({position: (position + rollDice()) % NUM_TILES}));
	}

	function rollDice() {
		return Std.random(6) + 1;
	}
}
