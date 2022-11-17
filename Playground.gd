extends Node2D
class_name GameScene

@onready var player_core := $Core
@onready var enemy_core := $Core2

var world: WorldManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup(_world: WorldManager) -> void:
	world = _world
	player_core.connect(player_core.end_battle.get_name(), world.battle_ended)
	enemy_core.connect(enemy_core.end_battle.get_name(), world.battle_ended)
