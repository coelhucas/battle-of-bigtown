extends HBoxContainer

@onready var selection_indicator := $Sprite2D
@onready var label_name := $VBoxContainer/Label
@onready var label_hp := $VBoxContainer/Attributes/Hp/Value
@onready var label_attack := $VBoxContainer/Attributes/Attack/Value
@onready var label_price := $VBoxContainer/Price
@onready var label_role := $VBoxContainer/Role
@onready var v_separator := $VSeparator

var stats: UnitStats

func _ready() -> void:
	selection_indicator.hide()

func display(_stats: UnitStats):
	stats = _stats
	label_name.text = _stats.name
	label_hp.text = str(_stats.hp)
	label_attack.text = str(_stats.damage)
	label_price.text = "Hire (-%s)" % str(_stats.price)
	label_price.modulate = Color.GREEN if Globals.gold >= _stats.price else Color.RED
	label_role.text = Enums.Class.keys()[_stats.role].capitalize()

func remove_separator() -> void:
	v_separator.queue_free()
