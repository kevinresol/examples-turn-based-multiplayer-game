package model;

import js.html.TransitionEvent;

class Game implements Model {
	@:constant var commands:Signal<Command>;
	@:observable var state:GameState = @byDefault InLobby(new Lobby({commands: commands}));

	function new() {
		commands.select(v -> v.selectGame()).handle(process);
	}

	function process(command:GameCommand) {
		prepare(command).handle(function(o) switch o {
			case Success(transition):
				transition.apply();
			case Failure(e):
				patch(e);
		});
	}

	@:transition
	private function patch(v)
		return v;

	public function prepare(command:GameCommand):Promise<Transition> {
		return switch [state, command] {
			case [InLobby(lobby), Join(name)]:
				lobby.players.add(name);
			case [InLobby(lobby), StartMatch]:
				switch lobby.players.count() {
					case 2:
						new Transition(patch.bind({
							state: InMatch(new Match({
								commands: commands,
								players: lobby.players
							}))
						}));

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
