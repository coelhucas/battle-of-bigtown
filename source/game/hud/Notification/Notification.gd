extends CenterContainer

signal acknowledged()

@onready var label := $MarginContainer/MarginContainer/VBoxContainer/Label

@onready var sfx_rest := $Sfx/Rest

func _ready():
	hide()
	set_process_input(false)


func show_notification(_which: Enums.Notification) -> void:
	show()
	set_process_input(true)
	match _which:
		Enums.Notification.ON_REST:
			label.text = "Action points restored\nParty consumed %s food" % str(Globals.population * Globals.FOOD_PER_UNIT)
			sfx_rest.play()
		Enums.Notification.DEBUFF_TIRED:
			label.text = "Your party will be weaker (-damage) on this battle\nsince they're tired."
		Enums.Notification.DEBUFF_HUNGRY:
			label.text = "Your party will be weaker (-defense) on this battle\nsince they're hungry."
		Enums.Notification.DEBUFF_TIRED_AND_HUNGRY:
			label.text = "Your party will be weaker (-attack and -defense) on this battle\nsince they're tired and hungry."
		Enums.Notification.WON_GAME:
			label.text = """You did it! Now your army command the biggest city
			of the continent and it's up to you to bring times of peace
			and propsperity to this land.
			
			Share your achievement with lord cuca(at)mastodon.gamedev.place
			~ Thanks for playing :)
			"""

func _input(event: InputEvent):
	if event.is_action_pressed("action_1"):
		hide()
		emit_signal("acknowledged")
		set_process_input(false)
	get_viewport().set_input_as_handled()
