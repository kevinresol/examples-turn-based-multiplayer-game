package model;

class Match implements Model {
	@:constant var commands:Signal<Command>;
	@:constant var players:Players;
	@:constant var board:Board = new Board();
	@:observable var currentTurn:Turn = new Turn({
		commands: commands,
		match: this,
		player: players.first()
	});

	function new() {
		commands.handle(process);
	}

	@:transition
	function process(command:Command) {
		return compute(command, true);
	}

	public function compute(command:Command, execute = false):Patch<Match> {
		return switch command {
			case _:
				new Error('[Match] cannot handle command ${command.getName()}');
		}
	}

	@:transition
	function nextTurn() {
		return {
			currentTurn: new Turn({
				commands: commands,
				match: this,
				player: players.next(currentTurn.player),
			}),
		}
	}
}
