package;

import model.Turn.TurnState;

@:asserts
class TurnTest {
	public function new() {}

	public function walk() {
		var commands = Signal.trigger();
		var game = Fixtures.started(commands);

		return switch game.state {
			case InLobby(_):
				asserts.fail('match should have started');
			case InMatch(match):
				asserts.assert(match.currentTurn.player.position == 0);

				commands.trigger(RollDice);
				asserts.assert(match.currentTurn.player.position > 0);

				asserts.done();
		}
	}

	public function purchase() {
		var commands = Signal.trigger();
		var game = Fixtures.started(commands);

		return switch game.state {
			case InLobby(_):
				asserts.fail('match should have started');
			case InMatch(match):
				asserts.assert(match.board.purchasedCount() == 0);

				commands.trigger(RollDice);
				commands.trigger(Purchase);
				asserts.assert(match.board.purchasedCount() > 0);

				asserts.done();
		}
	}

	@:variant([RollDice, Purchase, EndTurn])
	@:variant([RollDice, EndTurn])
	public function end(sequence:Array<Command>) {
		var commands = Signal.trigger();
		var game = Fixtures.started(commands);

		return switch game.state {
			case InLobby(_):
				asserts.fail('match should have started');
			case InMatch(match):
				var turn = match.currentTurn;
				for (command in sequence)
					commands.trigger(command);
				asserts.assert(turn.state == Ended);
				asserts.assert(match.currentTurn != turn, 'Match advanced to new turn');
				asserts.done();
		}
	}

	@:variant([StartMatch], Begin)
	@:variant([Purchase], Begin)
	@:variant([RollDice, RollDice], Walked)
	@:variant([RollDice, Purchase, Purchase], Purchased)
	@:variant([EndTurn], Begin)
	public function invalid(sequence:Array<Command>, state:TurnState) {
		var commands = Signal.trigger();
		var game = Fixtures.started(commands);

		return switch game.state {
			case InLobby(_):
				asserts.fail('match should have started');
			case InMatch(match):
				match.currentTurn.transitionErrors.nextTime().handle(function(e) {
					var expected = '[Turn] cannot handle command ${sequence[sequence.length - 1].getName()} in state ${state.getName()}';
					asserts.assert(e.message.startsWith(expected), expected);
					asserts.done();
				});

				for (command in sequence)
					commands.trigger(command);

				asserts;
		}
	}
}
