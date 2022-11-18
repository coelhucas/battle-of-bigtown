extends Node
class_name BaseEnemyState

var player: CharacterBody2D
@export var animation: String

func enter() -> void:
	var _suffix := ""
	if player.stats.role == Enums.Class.RANGED:
		_suffix += "_ranged"
	match player.creature:
		Enums.Creature.HUMAN:
			_suffix = "_human"
	
	if animation:
		player.animation.play(animation + _suffix)

func exit() -> void:
	pass

func update() -> BaseEnemyState:
	return null

func animation_finished() -> BaseEnemyState:
	return null
