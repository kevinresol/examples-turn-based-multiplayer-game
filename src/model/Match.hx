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

	@:transition
	private function patch(v)
		return v;

	public function prepare(command:Command):Promise<Transition> {
		return switch command {
			case _:
				new Error('[Match] cannot handle command ${command.getName()}');
		}
	}

	public function nextTurn():Promise<Transition> {
		return new Transition(patch.bind({
			currentTurn: new Turn({
				commands: commands,
				match: this,
				player: players.next(currentTurn.player),
			}),
		}));
	}
}
