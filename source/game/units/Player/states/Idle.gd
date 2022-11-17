extends BasePlayerState

@export var walk_state: BasePlayerState

func update() -> BasePlayerState:
	var direction: Vector2
	if player.playable:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
		if direction:
			return walk_state
	
	player.direction = direction
	return null

