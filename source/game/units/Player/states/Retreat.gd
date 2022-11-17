extends BasePlayerState

@export var look_for_target_state: BasePlayerState

const OFFSET_X := 32

var should_fight_back := false

func enter() -> void:
	super()
	player.stats.defending = true
	
	if not player.stats.is_connected(player.stats.aggro.get_name(), _on_aggro):
		player.stats.connect(player.stats.aggro.get_name(), _on_aggro)

func exit() -> void:
	super()
	player.stats.defending = false

func update() -> BasePlayerState:
	if not is_instance_valid(player.lead): return
	
	if player.global_position.distance_to(player.lead.global_position) > OFFSET_X:
		player.direction = player.global_position.direction_to(player.lead.global_position)
	else:
		player.direction = Vector2.ZERO
	
	if should_fight_back:
		return look_for_target_state

	return null

func _on_aggro() -> void:
	should_fight_back = true
