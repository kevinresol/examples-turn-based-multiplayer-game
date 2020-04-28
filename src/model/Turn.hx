package model;

import haxe.display.Display.SignatureItemKind;

class Turn implements Model {
	@:constant var commands:Signal<Command>;
	@:constant var player:Player;
	@:constant var match:Match;
	@:observable var state:TurnState = Begin;

	function new() {
		commands.select(v -> v.selectTurn()).handle(process);
	}

	function process(command:TurnCommand) {
		prepare(command).handle(function(o) switch o {
			case Success(transition):
				transition.apply();
			case Failure(e):
				patch(e); // trigger transition error
		});
	}

	@:transition
	private function patch(v)
		return v;

	public function prepare(command:TurnCommand):Promise<Transition> {
		return switch [state, command] {
			case [Begin, RollDice(value)]:
				player.walk(value).next(transition -> transition.chain(patch.bind({state: Walked})));

			case [Walked, Purchase]:
				var pos = player.position;
				var id = player.id;
				match.board.purchase(pos, id).next(transition -> transition.chain(patch.bind({state: Purchased})));

			case [Walked | Purchased, EndTurn]:
				match.nextTurn().next(transition -> transition.chain(patch.bind({state: Ended})));

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
