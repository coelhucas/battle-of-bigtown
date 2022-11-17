extends Area2D

signal end_battle(owner)

@export var owned_by_enemy := false
@export var stats: UnitStats

const PLAYER_CORE_MASK_BIT := 6
const ENEMY_CORE_MASK_BIT := 7

func _ready() -> void:
	stats = stats.duplicate()
	stats.make_a_name()
	stats.connect("died",  _on_died)
	if owned_by_enemy:
		set_collision_layer_value(ENEMY_CORE_MASK_BIT, true)
	else:
		set_collision_layer_value(PLAYER_CORE_MASK_BIT, true)

func _on_died() -> void:
	emit_signal("end_battle", Enums.Team.PLAYER if owned_by_enemy else Enums.Team.ENEMY)
	queue_free()
