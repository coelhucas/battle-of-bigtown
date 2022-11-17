extends Node

@export var initial_state: BaseEnemyState

var current_state: BaseEnemyState

func _ready() -> void:
	current_state = initial_state
	
func init(_player) -> void:
	for state in get_children():
		state.player = _player

func change_state(_new_state: BaseEnemyState) -> void:
	current_state.exit()
	current_state = _new_state
	current_state.enter()

func _physics_process(delta):
	var _new_state := current_state.update()
	if _new_state:
		change_state(_new_state)

func animation_finished(_anim_name: String) -> void:
	var _new_state := current_state.animation_finished()
	if _new_state:
		change_state(_new_state)
