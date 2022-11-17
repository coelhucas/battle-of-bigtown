extends Node

const MAX_ACTIONS := 3

var used_actions := 0
var gold := 100:
	set(_gold):
		gold = _gold
		EventBus.emit_signal("update_gold", gold)
var population := 0:
	set(_population):
		population = _population
		EventBus.emit_signal("update_population", population)

# Used and refreshed after each battle
var casualties := 0
var kills := 0
var earned_gold := 0
