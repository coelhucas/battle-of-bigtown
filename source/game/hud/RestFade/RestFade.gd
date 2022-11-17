extends ColorRect

@onready var animation := $AnimationPlayer

signal reached_black_screen()

func play() -> void:
	animation.play("rest")
	await get_tree().create_timer(0.4).timeout
	emit_signal("reached_black_screen")
