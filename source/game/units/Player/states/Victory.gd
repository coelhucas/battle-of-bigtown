extends BasePlayerState

func enter() -> void:
	super()
	player.direction = Vector2.ZERO
	player.do_cheer()
