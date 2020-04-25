package model;

class Players implements coconut.data.Model {
	@:constant var commands:Signal<Command>;
	@:observable var list:List<Option<Player>> = @byDefault [None, None];

	public inline function count() {
		return list.count(v -> v != None);
	}

	@:transition
	function process(command:Command) {
		return compute(command);
	}

	public function compute(command:Command):Patch<Players> {
		return switch command {
			case Join(name):
				add(name);
			case _:
				new Error('[Players] cannot handle command ${command.getName()}');
		}
	}

	function add(name:String):Patch<Players> {
		var slots = list.toArray();
		for (i in 0...slots.length)
			if (slots[i] == None) {
				slots[i] = Some(new Player({commands: commands, name: name}));
				return {list: List.fromArray(slots)}
			}
		return new Error('Game is full');
	}

	public function first():Player {
		for (slot in list)
			switch slot {
				case Some(player):
					return player;
				case _:
			}
		return null;
	}

	public function next(after:Player):Player {
		var matched = false;
		for (slot in list)
			switch slot {
				case Some(player):
					if (matched)
						return player;
					if (player == after)
						matched = true;
				case _:
			}
		return first();
	}
}
