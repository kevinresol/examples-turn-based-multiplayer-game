package model;

class Game implements Model {
	@:constant var commands:Signal<Command>;
	@:observable var state:GameState = @byDefault InLobby(new Lobby({commands: commands}));

	function new() {
		commands.handle(process);
	}

	@:transition
	function process(command:Command) {
		return compute(command, true);
	}

	public function compute(command:Command, execute = false):Patch<Game> {
		return switch [state, command] {
			case [InLobby(lobby), Join(name)]:
				(execute ? lobby.process(command) : lobby.compute(command).noise()).swap(@patch {});
			case [InLobby(lobby), StartMatch]:
				switch lobby.players.count() {
					case 2:
						{state: InMatch(new Match({commands: commands, players: lobby.players}))}
					case v:
						new Error('[Game] cannot start match with $v player(s)');
				}
			case _:
				new Error('[Game] cannot handle command ${command.getName()} in state ${state.getName()}');
		}
	}
}

enum GameState {
	InLobby(lobby:Lobby);
	InMatch(match:Match);
}
