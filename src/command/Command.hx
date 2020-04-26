package command;

@:using(command.Command.SelectionTools)
enum Command {
	Game(v:GameCommand);
	Turn(v:TurnCommand);
}

class SelectionTools {
	public static function selectGame(command:Command):Option<GameCommand> {
		return switch command {
			case Game(v): Some(v);
			case _: None;
		}
	}

	public static function selectTurn(command:Command):Option<TurnCommand> {
		return switch command {
			case Turn(v): Some(v);
			case _: None;
		}
	}
}
