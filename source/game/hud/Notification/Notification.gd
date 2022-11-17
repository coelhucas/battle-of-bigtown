extends CenterContainer

@onready var label := $MarginContainer/MarginContainer/VBoxContainer/Label

func _ready():
	hide()
	set_process_input(false)


func show_notification(_which: Enums.Notification) -> void:
	show()
	set_process_input(true)
	match _which:
		Enums.Notification.ON_REST:
			label.text = "Action points restored\nParty consumed %s food" % 23

func _input(event: InputEvent):
	if event.is_action_pressed("action_1"):
		hide()
		set_process_input(false)
		get_viewport().set_input_as_handled()
