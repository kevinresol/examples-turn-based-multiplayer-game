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

	public function walk(steps:Int):Promise<Transition> {
		return new Transition(patch.bind({position: (position + steps) % NUM_TILES}));
	}
}
