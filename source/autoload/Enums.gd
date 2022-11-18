extends Node
class_name Enums

enum PlayerCommand {
	NONE,
	DEFEND,
	ATTACK
}

enum Team {
	PLAYER,
	ENEMY
}

enum Action {
	RAID,
	REST,
	TRADE,
	RECRUIT,
	BUY_FOOD
}

enum ControlDisplay {
	ACTION_1_TO_SELECT,
	ACTION_1_TO_MOVE,
	ACTION_1_NOT_ENOUGH_ACTIONS,
	ACTION_2_TO_RETURN,
	ACTION_2_TO_NONE,
}

enum Creature {
	HUMAN
}

enum Notification {
	ON_REST,
	DEBUFF_TIRED,
	DEBUFF_HUNGRY,
	DEBUFF_TIRED_AND_HUNGRY,
	WON_GAME,
}

enum Buff {
	HUNGRY,
	TIRED,
	HEALTHY,
}

enum Class {
	MELEE,
	RANGED
}
