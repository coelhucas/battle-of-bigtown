extends CenterContainer

signal leave_battle()

@onready var container := $MarginContainer

func _ready() -> void:
	container.modulate.a = 0.0
	set_process_input(false)

func open() -> void:
	if container.modulate.a > 0.0: return
	
	container.modulate.a = 0.0
	var _tween := create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(container, "modulate:a", 1.0, 1.3)
	_tween.tween_callback(func():
		set_process_input(true)
	)

func close() -> void:
	container.modulate.a = 0
	var _tween := create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(container, "modulate:a", 0.0, 1.3)
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("action_1"):
		emit_signal("leave_battle")
