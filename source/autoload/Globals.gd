extends Node

const MAX_ACTIONS := 3
const FOOD_PACK_SIZE := 30
const FOOD_PRICE := 5
const FOOD_PER_UNIT := 2

var party_size := 0
var used_actions := 0:
	set(_used_actions):
		used_actions = _used_actions
		EventBus.emit_signal("update_actions", used_actions)
var gold := 100:
	set(_gold):
		gold = _gold
		EventBus.emit_signal("update_gold", gold)
var population := 0:
	set(_population):
		population = _population
		EventBus.emit_signal("update_population", population)
var food := 20:
	set(_food):
		food = _food
		EventBus.emit_signal("updated_food")
# Used and refreshed after each battle
var casualties := 0
var kills := 0
var earned_gold := 0
