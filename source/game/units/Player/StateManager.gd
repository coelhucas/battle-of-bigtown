extends Node

@export var initial_state: BasePlayerState
@export var look_for_target_state: BasePlayerState
@export var retreat_state: BasePlayerState
@export var cheer_state: BasePlayerState

var player: CharacterBody2D
var current_state: BasePlayerState

func _ready() -> void:
	current_state = initial_state
	EventBus.connect("battle_finished", _on_battle_finished)
	
func init(_player) -> void:
	player = _player
	for state in get_children():
		state.player = _player
	
	change_state(initial_state)


func receive_command(_command: Enums.PlayerCommand, _dir: int, _lead: CharacterBody2D) -> void:
	var _next_state: BasePlayerState
	player.target_direction = _dir
	player.lead = _lead
	match _command:
		Enums.PlayerCommand.ATTACK:
			_next_state = look_for_target_state
		Enums.PlayerCommand.DEFEND:
			_next_state = retreat_state
	change_state(_next_state)


func change_state(_new_state: BasePlayerState) -> void:
	if current_state:
		current_state.exit()
	current_state = _new_state
	current_state.enter()

func _input(event):
	var _new_state := current_state.input(event)
	if _new_state:
		change_state(_new_state)

func _physics_process(delta):
	var _new_state := current_state.update()
	if _new_state:
		change_state(_new_state)

func animation_finished(_anim_name: String) -> void:
	var _new_state := current_state.animation_finished()
	if _new_state:
		change_state(_new_state)

func _on_battle_finished(_winner: Enums.Team):
	if _winner == Enums.Team.PLAYER and not player.playable:
		change_state(cheer_state)
