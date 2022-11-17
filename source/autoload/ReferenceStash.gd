extends Node

@onready var SCENE_PLAYER_UNIT: PackedScene = preload("res://source/game/units/Player/Player.tscn")
@onready var SCENE_ENEMY_UNIT: PackedScene = preload("res://source/game/units/Enemy/Enemy.tscn")
@onready var SCENE_BATTLEGROUND: PackedScene = load("res://source/game/battle/Battleground.tscn")
@onready var SCENE_UNIT_INFORMATION: PackedScene = load("res://source/game/hud/Recruit/UnitInformation/UnitInformation.tscn")
@onready var SCENE_DEAD_BODY: PackedScene = load("res://source/game/battle/DeadBody.tscn")

@onready var SOUND_FX_COIN: AudioStream = load("res://assets/sound/fx_coin.wav")
