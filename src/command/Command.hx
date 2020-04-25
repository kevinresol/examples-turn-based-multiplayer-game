package command;

enum Command {
	StartMatch;
	Join(name:String);
	RollDice;
	Purchase;
	EndTurn;
}
