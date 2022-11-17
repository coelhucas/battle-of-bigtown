extends BasePlayerState

@export var look_for_target_state: BasePlayerState

func enter() -> void:
	super()
	player.direction = Vector2.ZERO
	

func animation_finished() -> BasePlayerState:
	if is_instance_valid(player.target):
		if player.global_position.distance_to(player.target.global_position) <= player.attack_range:
			if player.stats.has_hit():
				player.target.stats.take_damage(player.stats.damage)
			else:
				print("Player missed")
			return self
	return look_for_target_state
