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
	function purchase(tile:Int, byPlayer:Int) {
		return computePurchase(tile, byPlayer);
	}

	public function computePurchase(tile:Int, byPlayer:Int):Patch<Board> {
		return switch tiles.get(tile) {
			case -1:
				{tiles: tiles.with(tile, byPlayer)}
			case id:
				new Error('[Board] tile $tile is already purchased by player $byPlayer');
		}
	}
}
