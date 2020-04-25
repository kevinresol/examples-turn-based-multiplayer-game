package model;

class Player implements Model {
	static var ids = 0;

	@:constant var commands:Signal<Command>;
	@:constant var id:Int = ids++;
	@:constant var name:String;
	@:observable var position:Int = 0;

	// function new() {
	// 	commands.handle(process);
	// }

	@:transition
	function process(command:Command) {
		return compute(command);
	}

	public function compute(command:Command):Patch<Player> {
		return switch command {
			case RollDice:
				var steps = rollDice();
				{position: (position + steps) % NUM_TILES}
			case _:
				new Error('[Player] cannot handle command ${command.getName()}');
		}
	}

	function rollDice() {
		return Std.random(6) + 1;
	}
}
