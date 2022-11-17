extends Control

@onready var label_defend := $VBoxContainer/HBoxContainer/DefendLabel
@onready var label_attack := $VBoxContainer/HBoxContainer/AttackLabel
@onready var label_cancel := $VBoxContainer/CancelLabel

func set_action(_action: Enums.PlayerCommand):
	label_defend.modulate.a = 0.6
	label_attack.modulate.a = 0.6
	label_cancel.modulate.a = 0.6
	match _action:
		Enums.PlayerCommand.NONE:
			label_cancel.modulate.a = 1.0
		Enums.PlayerCommand.ATTACK:
			label_attack.modulate.a = 1.0
		Enums.PlayerCommand.DEFEND:
			label_defend.modulate.a = 1.0
