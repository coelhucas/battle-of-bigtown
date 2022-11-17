extends Node
class_name BasePlayerState

var player: CharacterBody2D
@export var animation: String

func enter() -> void:
	var _suffix: String = "_playable" if player.playable else ""
	if animation:
		player.animation.play(animation + _suffix)

func exit() -> void:
	pass

func input(event: InputEvent) -> BasePlayerState:
	return null

func update() -> BasePlayerState:
	return null

func animation_finished() -> BasePlayerState:
	return null
