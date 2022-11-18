extends CenterContainer

signal leave_battle()

const RESULT_STRING := "--- You %s the battle ---"

@onready var add_coin_timer := $AddCoinTimer
@onready var container := $MarginContainer
@onready var label_result := $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/Result
@onready var label_kills := $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/Kills/Value
@onready var label_casualties := $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/Casualties/Value
@onready var label_gold := $MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/Gold/Value

@onready var sfx_victory := $Sfx/Victory
@onready var sfx_defeat := $Sfx/Defeat

var last_winner: Enums.Team
var displayed_coins := 0
var total_coins := 1

func _ready() -> void:
	container.modulate.a = 0.0
	set_process_input(false)

func open(_winner: Enums.Team, _gold: int = 0) -> void:
	if container.modulate.a > 0.0: return
	last_winner = _winner
	displayed_coins = 0
	total_coins = _gold
	
	if _winner == Enums.Team.PLAYER:
		add_coin_timer.wait_time = clamp(1 / _gold * 0.2, 0.05, 2.0)
		label_result.text = RESULT_STRING % "won"
		sfx_victory.play()
	else:
		label_result.text = RESULT_STRING % "lost"
		sfx_defeat.play()
	
	label_kills.text = str(Globals.kills)
	label_casualties.text = str(Globals.casualties)
	label_gold.text = str(displayed_coins)
	
	container.modulate.a = 0.0
	var _tween := create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(container, "modulate:a", 1.0, 1.3)
	_tween.tween_callback(func():
		set_process_input(true)
		add_coin_timer.start()
	)

func close() -> void:
	container.modulate.a = 0
	var _tween := create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(container, "modulate:a", 0.0, 1.3)
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("action_1") and add_coin_timer.is_stopped():
		emit_signal("leave_battle", last_winner)
	elif event.is_action_pressed("action_1") and not add_coin_timer.is_stopped():
		label_gold.text = str(total_coins)
		add_coin_timer.stop()


func _on_add_coin_timer_timeout():
	if displayed_coins < total_coins:
		displayed_coins += 1
		label_gold.text = str(displayed_coins)
		
		var _sound: AudioStreamFree = AudioStreamFree.new()
		_sound.stream = ReferenceStash.SOUND_FX_COIN
		add_child(_sound)
		_sound.play()
	else:
		add_coin_timer.stop()
