extends Resource
class_name GameLocation

@export var name: String
@export_multiline var description: String
@export var available_actions: Array[Enums.Action]
@export var army: Array[UnitStats]
@export var population: Array[UnitStats]
@export var hostile: bool = false
@export_range(1.0, 10.0) var base_strength: float
@export_range(1, 1000) var population_size: int

# 70%
const POPULATION_TO_ARMY_RATIO := 0.5

var just_fighted: bool = false
var available_for_hire: Array[UnitStats]
var base_price := 5

func generate_population() -> void:
	randomize()
	if army.size() < population_size / 2:
		army = []
	else:
		return

	for i in population_size:
		var _chance := randf_range(0.0, 100.0)
		var _unit: UnitStats = UnitStats.new()
		_unit.make_a_name()
		_unit.damage = 1.5 * clamp(randi_range(base_strength - 3, base_strength + 3), 1, 10)
		_unit.max_hp = 10 * clamp(randi_range(base_strength - 3, base_strength + 3), 1, 10)
		_unit.hp = _unit.max_hp
		_unit.price = int(base_price * _unit.damage / 1.5 * _unit.hp / 10.0)
		
		if _chance < 30:
			_unit.role = Enums.Class.RANGED
		
		population.append(_unit)
	
	var _army_size := int(population_size * POPULATION_TO_ARMY_RATIO)
	for i in _army_size:
		army.append(population.pop_back())


func get_for_hire() -> Array[UnitStats]:
	available_for_hire = population.slice(0, 8)
	return available_for_hire


func get_gold_prize(_casualties: int) -> int:
	var _value: int = clamp(int(clamp(base_strength, 1, 10) * population_size * 2) - _casualties, 0, 99999999)
	Globals.earned_gold = _value
	return _value
