extends Node

@onready var test := preload("res://Playground.tscn")
@onready var map := preload("res://source/game/map/Map.tscn")

@onready var world := $World


# UI
@onready var result_screen := $UI/ResultScreen

var last_location: GameLocation
var gold := 50:
	set(_gold):
		gold = _gold
		Globals.gold = gold
var population := 1:
	set(_population):
		population = _population
		EventBus.emit_signal("update_population", population)
var used_actions := 0:
	set(_actions):
		used_actions = _actions
		Globals.used_actions = used_actions
		EventBus.emit_signal("update_actions", used_actions)

func _ready() -> void:
	world.game_manager = self
	var _map_scene: Node2D = world.change_scene(map)
	_map_scene.set_location(world.initial_location)
	world.connect(world.battle_finished.get_name(), _on_battle_finished)
	world.connect(world.save_last_location.get_name(), _on_saved_last_location)
	result_screen.connect(result_screen.leave_battle.get_name(), _on_left_battle)
	EventBus.connect(EventBus.attempt_purchase.get_name(), _on_attempt_purchase)
	EventBus.connect("rest_party", _on_rest)
	EventBus.connect("consume_action_point", func(_amount: int):
		used_actions += _amount
	)

func _on_battle_finished(_winner: Enums.Team) -> void:
	print("Winner team was %s" % Enums.Team.keys()[_winner])
	EventBus.emit_signal("battle_finished", _winner)
	result_screen.open()
	
	if _winner == Enums.Team.PLAYER:
		Globals.gold += last_location.get_gold_prize()

func _on_left_battle():
	var _map_scene: Node2D = world.change_scene(map)
	_map_scene.set_location(last_location)
	result_screen.close()
	

func _on_saved_last_location(_last_location: MapNode):
	last_location = _last_location.location

func _on_attempt_purchase(_unit: UnitStats):
	if Globals.gold >= _unit.price:
		Globals.gold -= _unit.price
		world.party.append(_unit.duplicate())
		Globals.population = world.party.size()
		EventBus.emit_signal("purchased", _unit)
	else:
		push_error("You are poor")

func _on_rest():
	# TODO: remove food
	used_actions = 0
