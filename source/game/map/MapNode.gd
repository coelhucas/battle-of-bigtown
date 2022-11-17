extends Area2D
class_name MapNode

signal selected(node)

@export var location: GameLocation
@export var goes_to: Array[NodePath]
@export var texture: Texture2D
@onready var sprite := $Sprite2D
@onready var current_indicator := $CurrentIndicator

var is_locked: bool = false

var is_current := false:
	set(_is_current):
		is_current = _is_current
		sprite.material.set_shader_parameter("is_enabled", not reachable and not is_current)
		current_indicator.visible = is_current
		
var locations: Array[MapNode]
var reachable := false:
	set(_reachable):
		reachable = _reachable
		sprite.material.set_shader_parameter("is_enabled", not reachable and not is_current)

var _tween: Tween


func _ready() -> void:
	sprite.texture = texture
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("is_enabled", not reachable and not is_current)
	current_indicator.visible = is_current
	if location:
		location.generate_population()
	
	for _loc in goes_to:
		locations.append(get_node(_loc))


func focus():
	if is_instance_valid(_tween) and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(sprite, "scale", Vector2.ONE * 1.2, 0.3)


func remove_reachables() -> void:
	is_current = false
	for _loc in locations:
		_loc.reachable = false

func add_reachables() -> void:
	is_current = true
	for _loc in locations:
		_loc.reachable = true

func remove_unit(_unit: UnitStats) -> void:
	location.population.erase(_unit)
	location.available_for_hire.erase(_unit)
	
func reset_population() -> void:
	location.just_fighted = true

func unfocus():
	if is_instance_valid(_tween) and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_BACK)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.3)


func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_pressed("mouse_left") and reachable:
		emit_signal("selected", self)
