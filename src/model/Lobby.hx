package model;

class Lobby implements Model {
	@:constant var commands:Signal<Command>;
	@:observable var players:Players = @byDefault new Players({commands: commands});

	@:transition
	function process(command:Command) {
		return compute(command, true);
	}

	public function compute(command:Command, execute = false):Patch<Lobby> {
		return switch command {
			case Join(name):
				(execute ? players.process(command) : players.compute(command).noise()).swap(@patch {});

			case _:
				new Error('[Lobby] cannot handle command ${command.getName()}');
		}
	}
}
