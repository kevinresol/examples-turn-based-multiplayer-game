package;

@:asserts
class GameTest {
	public function new() {}

	public function join() {
		var commands = Signal.trigger();
		var game = new Game({commands: commands});

		function check(v) {
			switch game.state {
				case InLobby(lobby):
					asserts.assert(lobby.players.count() == v);
				case InMatch(_):
					asserts.fail('match started unexpectedly');
			}
		}

		commands.trigger(Join('Foo'));
		check(1);

		commands.trigger(Join('Bar'));
		check(2);

		return asserts.done();
	}

	public function start() {
		var commands = Signal.trigger();
		var game = Fixtures.fullyJoined(commands);
		commands.trigger(StartMatch);

		switch game.state {
			case InLobby(lobby):
				asserts.fail('match should have started');
			case InMatch(match):
				asserts.assert(match.players.count() == 2);
		}

		return asserts.done();
	}
}
