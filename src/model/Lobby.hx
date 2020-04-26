package model;

class Lobby implements Model {
	@:constant var commands:Signal<Command>;
	@:observable var players:Players = @byDefault new Players({commands: commands});
}
