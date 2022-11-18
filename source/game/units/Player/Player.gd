extends CharacterBody2D
class_name PlayerUnit

signal command(action)

@export var playable: bool:
	set(_playable):
		playable = _playable
		state_manager.current_state.enter()
		if playable:
			set_process_input(true)
			avoid_solids.queue_free()
			move_speed = PLAYER_SPEED
@export var stats: UnitStats
@onready var sprite := $Sprite2D
@onready var cheering_sounds := $CheerAudios
@onready var command_area := $CommandArea
@onready var animation := $AnimationPlayer
@onready var state_manager := $StateManager
@onready var action_display := $ActionDisplay
@onready var fov_radius: Area2D = $FOVRadius
@onready var selection_indicator := $SelectionIndicator
@onready var avoid_solids := $AvoidSolids
@onready var ray_front := $AvoidSolids/Right

@onready var sfx_command := $FxCommand
@onready var sfx_attack := $FxAttack
@onready var sfx_defend := $FxDefend

const AI_SPEED = 40.0
const PLAYER_SPEED := 60.0
const MELEE_RANGE := 8
const RANGED_RANGE := 128

var range := MELEE_RANGE
var units_in_command_range: Array
var move_speed := AI_SPEED
var facing_dir := 1.0:
	set(_facing_dir):
		facing_dir = _facing_dir
		if facing_dir > 0:
			sprite.flip_h = false
		elif facing_dir < 0:
			sprite.flip_h = true
var target_direction: int = 1
var direction: Vector2
var selecting_order := false
var selected_action := Enums.PlayerCommand.NONE

var target: CollisionObject2D
var lead: CharacterBody2D

func _ready() -> void:
	set_process_input(false)
	state_manager.init(self)
	animation.connect("animation_finished", state_manager.animation_finished)
	for ray in avoid_solids.get_children():
		ray.add_exception(self)
	
func setup_stats() -> void:
	stats.make_a_name()
	stats.connect("died", _on_died)
	
	if stats.role == Enums.Class.RANGED:
		range = RANGED_RANGE


func get_units_in_range() -> Array:
	if selecting_order and command_area.has_overlapping_bodies():
		units_in_command_range = command_area.get_overlapping_bodies()
	else:
		units_in_command_range = []
	return units_in_command_range


func _input(event: InputEvent):
	if event.is_action_pressed("action_2"):
		selecting_order = true
		sfx_command.play()
		action_display.show()
		
		var _units_in_range: Array = get_units_in_range()
		for _unit in _units_in_range:
			if not _unit.playable:
				_unit.show_selection()
	
	if event.is_action_released("action_2") and selecting_order:
		if Input.is_action_pressed("ui_left"):
			pass
		for _unit in units_in_command_range:
			if is_instance_valid(_unit):
				_unit.hide_selection()

		if selecting_order and selected_action != Enums.PlayerCommand.NONE:
			for node in units_in_command_range:
				if is_instance_valid(node) and not node.playable:
					node.state_manager.receive_command(selected_action, facing_dir, self)
					node.hide_selection()
			
		if selected_action == Enums.PlayerCommand.ATTACK:
			sfx_attack.play()
			
		if selected_action == Enums.PlayerCommand.DEFEND:
			sfx_defend.play()
		
		selecting_order = false
		selected_action = Enums.PlayerCommand.NONE
		action_display.hide()

func _process(delta):
	if playable:
		if Input.is_action_just_pressed("ui_left"):
			selected_action = Enums.PlayerCommand.DEFEND
			action_display.set_action(selected_action)
	
		if Input.is_action_just_pressed("ui_right"):
			selected_action = Enums.PlayerCommand.ATTACK
			action_display.set_action(selected_action)
		
		if Input.is_action_just_released("ui_left") and selected_action == Enums.PlayerCommand.DEFEND:
			selected_action = Enums.PlayerCommand.NONE
			action_display.set_action(selected_action)
		
		if Input.is_action_just_released("ui_right") and selected_action == Enums.PlayerCommand.ATTACK:
			selected_action = Enums.PlayerCommand.NONE
			action_display.set_action(selected_action)


func _physics_process(delta):
#	$Label.text = state_manager.current_state.name
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.y = move_toward(velocity.y, 0, move_speed)
#
	if not playable:
		avoid_solids.look_at(global_position + velocity.normalized() * 100)
		if ray_front.is_colliding():
			avoid_solids.scale.x = sign(facing_dir)
			avoid_obstacles()

	if not selecting_order or not playable:
		if direction.x != 0:
			facing_dir = sign(direction.x)
		
		if direction:
			move_and_slide()

func _on_died() -> void:
	Globals.casualties += 1
	EventBus.emit_signal("unit_died", self)
	if playable:
		EventBus.emit_signal("player_died")
	
	queue_free()

func show_selection() -> void:
	selection_indicator.show()

func hide_selection() -> void:
	selection_indicator.hide()


func _on_command_area_body_exited(body):
	if playable:
		body.hide_selection()
	
	if not playable and body.playable:
		lead = body
		command_area.queue_free()


func avoid_obstacles():
	var _viable_ray: RayCast2D
	for ray in avoid_solids.get_children():
		if not ray.is_colliding():
			_viable_ray = ray
			break
	
	if _viable_ray:
		velocity = Vector2.RIGHT.rotated(avoid_solids.rotation + _viable_ray.rotation) * move_speed


func do_cheer() -> void:
	var _idx: int = randi() % cheering_sounds.get_child_count()
	await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
	cheering_sounds.get_child(_idx).play()
