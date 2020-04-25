package;

class Fixtures {
	static function players(commands, names:Array<String>) {
		return new Players({commands: commands, list: names.map(v -> Some(player(commands, v)))});
	}

	static function player(commands, name) {
		return new Player({commands: commands, name: name});
	}

	public static function fullyJoined(commands) {
		var players = players(commands, ['Foo', 'Bar']);
		var lobby = new Lobby({commands: commands, players: players});
		return new Game({commands: commands, state: InLobby(lobby)});
	}

	public static function started(commands) {
		var players = players(commands, ['Foo', 'Bar']);
		var match = new Match({commands: commands, players: players});
		return new Game({commands: commands, state: InMatch(match)});
	}
}
