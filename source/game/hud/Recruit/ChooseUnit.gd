extends CenterContainer

@onready var container := $MarginContainer/MarginContainer/Container
@onready var label_availability := $Label
@onready var sfx_confirm := $SfxConfirm

var origin: MapNode

var _selected_option: int = 0:
	set(_selected):
		if _selected_option != _selected and _selected_option < container.get_child_count():
			var _previous_opt: Control = container.get_child(_selected_option)
			if is_instance_valid(_previous_opt):
				_previous_opt.selection_indicator.hide()
		
		if container.get_child_count() == 0: return
		_selected_option = clamp(_selected, 0, container.get_child_count() - 1)
		var _new_opt: Control = container.get_child(_selected_option)
		_new_opt.selection_indicator.show()

func _ready() -> void:
	hide()
	EventBus.connect("purchased", _on_purchased)
	set_process_input(false)
	
func _input(event: InputEvent):
	_selected_option = clamp(_selected_option, 0, container.get_child_count() - 1)
	if event.is_action_pressed("action_1") and container.get_children().size():
		EventBus.emit_signal(EventBus.attempt_purchase.get_name(), container.get_child(_selected_option).stats)
	
	if event.is_action_pressed("ui_left"):
		_selected_option = wrapi(_selected_option - 1, 0, container.get_child_count())
	
	if event.is_action_pressed("ui_right"):
		_selected_option = wrapi(_selected_option + 1, 0, container.get_child_count())

func close() -> void:
	for opt in container.get_children():
		opt.queue_free()
	hide()

func show_options(_options: Array[UnitStats]) -> void:
	show()
	for child in container.get_children():
		child.queue_free()
	
	var _named_options: Array[UnitStats] = _options.map(func (_opt: UnitStats):
		_opt.make_a_name()
		return _opt
	)
	
	var _idx: int = 0
	
	for _unit in _named_options:
		var _unit_info: Control = ReferenceStash.SCENE_UNIT_INFORMATION.instantiate()
		container.add_child(_unit_info)
		_unit_info.display(_unit)
		_unit_info.selection_indicator.visible = _idx == _selected_option
		_idx += 1

	var _last_child: Control = container.get_child(container.get_child_count() - 1)
	if is_instance_valid(_last_child) and not _last_child.is_queued_for_deletion():
		_last_child.remove_separator()
#	container.get_child(_selected_option).selection_indicator.show()
	label_availability.visible = _options.is_empty()

func _on_purchased(_unit: UnitStats) -> void:
	origin.remove_unit(_unit)
	_selected_option = wrapi(_selected_option, 0, origin.location.population.size())
	sfx_confirm.play()
	# Update options
	show_options(origin.location.available_for_hire)
