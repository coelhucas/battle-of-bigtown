extends BaseEnemyState

@export var look_for_target_state: BaseEnemyState

func enter() -> void:
	super()
	player.direction = Vector2.ZERO
	player.set_physics_process(false)

func exit() -> void:
	super()
	player.set_physics_process(true)
	

func animation_finished() -> BaseEnemyState:
	if is_instance_valid(player.target):
		if player.global_position.distance_to(player.target.global_position) <= player.range:
			if player.stats.has_hit():
				player.target.stats.take_damage(player.stats.damage)
			return self
	return look_for_target_state
