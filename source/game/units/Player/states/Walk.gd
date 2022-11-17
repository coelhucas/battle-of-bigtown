extends BasePlayerState

@export var idle_state: BasePlayerState

func update() -> BasePlayerState:
	var direction: Vector2
	
	if player.playable:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		player.direction = direction
	
		if direction == Vector2.ZERO:
			return idle_state
	
	return null

