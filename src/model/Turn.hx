package model;

class Turn implements Model {
	@:constant var commands:Signal<Command>;
	@:constant var player:Player;
	@:constant var match:Match;
	@:observable var state:TurnState = Begin;

	function new() {
		commands.handle(process);
	}

	@:transition
	function process(command:Command) {
		return compute(command, true);
	}

	public function compute(command:Command, execute = false):Patch<Turn> {
		return switch [state, command] {
			case [Begin, RollDice]:
				(execute ? player.process(command) : player.compute(command).noise()).swap({state: Walked});

			case [Walked, Purchase]:
				var pos = player.position;
				var id = player.id;
				(execute ? match.board.purchase(pos, id) : match.board.computePurchase(pos, id).noise()).swap({state: Purchased});

			case [Walked | Purchased, EndTurn]:
				match.nextTurn();
				{state: Ended};

			case _:
				new Error('[Turn] cannot handle command ${command.getName()} in state ${state.getName()}');
		}
	}
}

enum TurnState {
	Begin;
	Walked;
	Purchased;
	Ended;
}
