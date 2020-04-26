package model;

class Board implements Model {
	// tile number => player id
	@:observable var tiles:Mapping<Int, Int> = [for (i in 0...NUM_TILES) i => -1];

	public function purchasedCount() {
		var sum = 0;
		for (v in tiles)
			if (v != -1)
				sum++;
		return sum;
	}

	@:transition
	private function patch(v)
		return v;

	public function purchase(tile:Int, byPlayer:Int):Promise<Transition> {
		return switch tiles.get(tile) {
			case -1:
				new Transition(patch.bind({tiles: tiles.with(tile, byPlayer)}));
			case id:
				new Error('[Board] tile $tile is already purchased by player $byPlayer');
		}
	}
}
