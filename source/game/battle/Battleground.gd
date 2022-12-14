extends Node2D

@onready var player_spawn := $PlayerSpawnArea
@onready var enemy_spawn := $EnemySpawnArea

@onready var player_core := $PlayerCore
@onready var enemy_core := $EnemyCore

@onready var graveyard := $Graveyard

var player_spawn_area: Rect2
var enemy_spawn_area: Rect2

func _ready() -> void:
	player_spawn_area = (player_spawn.get_child(0) as CollisionShape2D).get_shape().get_rect()
	enemy_spawn_area = (enemy_spawn.get_child(0) as CollisionShape2D).get_shape().get_rect()
	EventBus.connect("unit_died", _on_unit_died)


func setup(_world: WorldManager) -> void:
	player_core.connect(player_core.end_battle.get_name(), _world.battle_ended)
	enemy_core.connect(enemy_core.end_battle.get_name(), _world.battle_ended)
	Globals.earned_gold = 0
	Globals.casualties = 0
	Globals.kills = 0



func spawn_player(_stats: UnitStats, _playable: bool = false) -> void:
	var _unit_scene: Node2D = ReferenceStash.SCENE_PLAYER_UNIT.instantiate()
	add_child(_unit_scene)
	if _stats.role == Enums.Class.RANGED:
		_unit_scene.global_position = Vector2(
			player_spawn.global_position.x + randi_range(player_spawn_area.position.x, player_spawn_area.size.x / 4),
			player_spawn.global_position.y + randi_range(player_spawn_area.position.y, player_spawn_area.size.y / 4),
		)
	else:
		_unit_scene.global_position = Vector2(
			player_spawn.global_position.x + randi_range(player_spawn_area.position.x + player_spawn_area.size.x / 4, player_spawn_area.size.x / 2),
			player_spawn.global_position.y + randi_range(player_spawn_area.position.y + player_spawn_area.size.y / 4, player_spawn_area.size.y / 2),
		)
	
	_unit_scene.playable = _playable
	_unit_scene.stats = _stats
	_unit_scene.setup_stats()
	
	if not _stats.is_connected("died", _on_unit_died.bind(_unit_scene)):
		_stats.connect("died", _on_unit_died.bind(_unit_scene))


func spawn(_player_party: Array[UnitStats], _enemy_party: Array[UnitStats]) -> void:
	randomize()
	for _stats in _player_party:
		spawn_player(_stats)
	
	spawn_player(UnitStats.new(), true)
		
		
	for _unit in _enemy_party:
		var _unit_scene: Node2D = ReferenceStash.SCENE_ENEMY_UNIT.instantiate()
		add_child(_unit_scene)
		if _unit.role == Enums.Class.RANGED:
			_unit_scene.global_position = Vector2(
				enemy_spawn.global_position.x + randi_range(enemy_spawn_area.position.x + enemy_spawn_area.size.x / 4, enemy_spawn_area.size.x / 2),
				enemy_spawn.global_position.y + randi_range(enemy_spawn_area.position.y + enemy_spawn_area.size.x / 4, enemy_spawn_area.size.y / 2),
			)
		else:
			_unit_scene.global_position = Vector2(
				enemy_spawn.global_position.x + randi_range(enemy_spawn_area.position.x, enemy_spawn_area.size.x / 4),
				enemy_spawn.global_position.y + randi_range(enemy_spawn_area.position.y, enemy_spawn_area.size.y / 4),
			)
		_unit_scene.stats = _unit
		_unit_scene.stats.connect("died", _on_unit_died.bind(_unit_scene))
		_unit_scene.setup_stats()

func _on_unit_died(_scene: CharacterBody2D):
	var _body: Node2D = ReferenceStash.SCENE_DEAD_BODY.instantiate()
	graveyard.add_child(_body)
	_body.global_position = _scene.global_position
	
	var _sfx: AudioStreamFree = AudioStreamFree.new()
	_sfx.stream = ReferenceStash.SOUND_FX_DEATH
	_sfx.volume_db = -50.0
	add_child(_sfx)
	_sfx.play()
