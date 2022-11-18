extends BasePlayerState

@export var attack_state: BasePlayerState

func enter() -> void:
	super()
	player.fov_radius.monitoring = true
	
	for ray in player.avoid_solids.get_children():
		ray.enabled = true

func exit() -> void:
	super()
	player.fov_radius.monitoring = false
	
	for ray in player.avoid_solids.get_children():
		ray.enabled = false

func get_closest_enemy() -> CharacterBody2D:
	var _closest_dist := 9999
	var _target: CharacterBody2D
	for _body in player.fov_radius.get_overlapping_bodies():
		if _body.global_position.distance_to(player.global_position) < _closest_dist:
			_closest_dist = _body.global_position.distance_to(player.global_position)
			_target = _body
	return _target

func update() -> BasePlayerState:
	if is_instance_valid(player.target):
		player.direction = player.global_position.direction_to(player.target.global_position)
		if player.global_position.distance_to(player.target.global_position) <= player.range:
			return attack_state
	elif player.fov_radius.has_overlapping_bodies():
		player.target = get_closest_enemy()
	elif player.fov_radius.has_overlapping_areas():
		player.target = player.fov_radius.get_overlapping_areas()[0]
	else:
		player.direction = Vector2.RIGHT * player.target_direction
	
	return null

