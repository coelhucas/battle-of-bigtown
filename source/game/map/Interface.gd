extends Control

@onready var label_action_1 := $ControlsDisplay/Action1
@onready var label_action_2 := $ControlsDisplay/Action2

func display_control(_which: Enums.ControlDisplay):
	match _which:
		Enums.ControlDisplay.ACTION_1_TO_SELECT:
			label_action_1.text = "Z to select"
		Enums.ControlDisplay.ACTION_1_TO_MOVE:
			label_action_1.text = "Z to move (uses 1 action point)"
		Enums.ControlDisplay.ACTION_2_TO_RETURN:
			label_action_2.text = "X to go back to map"
		Enums.ControlDisplay.ACTION_1_NOT_ENOUGH_ACTIONS:
			label_action_1.text = "Your party is too tired to travel. You need to rest."
		Enums.ControlDisplay.ACTION_2_TO_NONE:
			label_action_2.text = ""
