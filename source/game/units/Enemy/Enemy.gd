extends CharacterBody2D

const SPEED := 40.0

@onready var sprite := $Sprite2D
@onready var fov_radius := $FOVRadius
@onready var state_manager := $StateManager
@onready var animation := $AnimationPlayer
@export var stats: UnitStats
@export var creature: Enums.Creature

var target: CollisionObject2D
var direction: Vector2
var attack_range := 8
var hp := 5:
	set(_hp):
		hp = _hp
		
		if hp <= 0:
			queue_free()

func _ready() -> void:
	state_manager.init(self)
	stats = stats.duplicate()
	stats.make_a_name()
	animation.connect("animation_finished", state_manager.animation_finished)
	stats.connect("died",  _on_died)

func _physics_process(delta):
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _on_died() -> void:
	EventBus.emit_signal("unit_died", self)
	queue_free()
