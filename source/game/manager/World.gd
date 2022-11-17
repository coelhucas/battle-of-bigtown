extends Node2D
class_name WorldManager

@export var party: Array[UnitStats]
@export var initial_location: GameLocation

signal battle_finished(winner)
signal save_last_location(loc)

var game_manager: Node

func _ready() -> void:
	EventBus.connect(EventBus.player_died.get_name(), _on_player_died)

func change_scene(_new_scene: PackedScene) -> Node2D:
	for child in get_children():
		child.queue_free()
	
	var _scene := _new_scene.instantiate()
	add_child(_scene)
	_scene.setup(self)
	return _scene

func _on_player_died() -> void:
	battle_ended(Enums.Team.ENEMY)
	
func battle_ended(_winner: Enums.Team) -> void:
	emit_signal(battle_finished.get_name(), _winner)

func start_battle(_node: MapNode) -> void:
	var _battleground: Node2D = change_scene(ReferenceStash.SCENE_BATTLEGROUND)
	_battleground.spawn(party, _node.location.army)
	emit_signal("save_last_location", _node)
