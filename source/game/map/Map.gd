extends Node2D

enum State {
	SELECTING_NODE,
	SELECTING_ACTION,
	RECRUITING,
}

signal start_battle(enemies_party)

@onready var notification := $Control/Notification
@onready var rest_menu := $Control/RestMenu
@onready var label_target_name: Label = $Control/TargetName
@onready var interface := $Control
@onready var status_display := $Control/StatusDisplay
@onready var recruiting_menu := $Control/ChooseUnit
@onready var location_menu := $Control/LocationMenu
@onready var nodes_container := $Nodes
@onready var current_node: MapNode:
	set(_node):
		if current_node:
			current_node.remove_reachables()
			
			if _node != current_node:
				current_node.location.just_fighted = false
			
		current_node = _node
		current_node.add_reachables()
		_reachables = []
		_reachables.append(current_node)
		_reachables.append_array(current_node.locations)
		_current_index = 0
		
		if current_node.location:
			location_menu.display(current_node.location)
		queue_redraw()
		
var _current_index: int = 0:
	set(_index):
		if _current_index < _reachables.size():
			_reachables[_current_index].unfocus()
		_current_index = _index
		_reachables[_current_index].focus()
		label_target_name.text = _reachables[_current_index].location.name
		
		if current_node == _reachables[_current_index]:
			interface.display_control(Enums.ControlDisplay.ACTION_1_TO_SELECT)
		elif Globals.used_actions < Globals.MAX_ACTIONS:
			interface.display_control(Enums.ControlDisplay.ACTION_1_TO_MOVE)
		else:
			interface.display_control(Enums.ControlDisplay.ACTION_1_NOT_ENOUGH_ACTIONS)
		queue_redraw()
var _reachables: Array[MapNode] = []

var _state: State = State.SELECTING_NODE:
	set(_new_state):
		_state = _new_state
		location_menu.visible = _state == State.SELECTING_ACTION
		location_menu.set_process_input(_state == State.SELECTING_ACTION)
		
		if _state == State.SELECTING_ACTION:
			location_menu.focus_option()
			interface.display_control(Enums.ControlDisplay.ACTION_2_TO_RETURN)
		if _state == State.SELECTING_NODE:
			interface.display_control(Enums.ControlDisplay.ACTION_2_TO_NONE)

func setup(_world: WorldManager):
	connect(start_battle.get_name(), _world.start_battle)
	status_display.update_initials(_world.game_manager.used_actions, Globals.gold, Globals.population)


func set_location(_loc: GameLocation, _reset_current_location: bool = false):
	if current_node:
		current_node.unfocus()
	
	for loc in nodes_container.get_children():
		if loc.location.name == _loc.name:
			current_node = loc
			if _reset_current_location:
				current_node.reset_population()
			break
	
	location_menu.connect(location_menu.selected_action.get_name(), _on_selected_action)
	for _node in nodes_container.get_children():
		if _node is MapNode:
			_node.connect(_node.selected.get_name(), _on_selected_node)
	
	current_node.add_reachables()
	current_node.focus()
	_reachables.append(current_node)
	_reachables.append_array(current_node.locations)
	label_target_name.text = _reachables[_current_index].location.name
	queue_redraw()
	


func _on_selected_node(_node) -> void:
	current_node = _node

func _handle_node_selection(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		_current_index = wrapi(_current_index + 1, 0, _reachables.size())
	
	if event.is_action_pressed("ui_left"):
		_current_index = wrapi(_current_index - 1, 0, _reachables.size())
	
	if event.is_action_pressed("action_1"):
		if Globals.used_actions < Globals.MAX_ACTIONS or current_node == _reachables[_current_index]:
			if current_node != _reachables[_current_index]:
				EventBus.emit_signal("consume_action_point", 1)
				
			current_node = _reachables[_current_index]
			_state = State.SELECTING_ACTION

func _handle_action_selection(event: InputEvent) -> void:
	if event.is_action_pressed("action_2"):
		_state = State.SELECTING_NODE

func _handle_recruiting_selection(event: InputEvent):
	if event.is_action_pressed("action_2"):
		recruiting_menu.set_process_input(false)
		recruiting_menu.close()
		location_menu.set_process_input(true)
		_state = State.SELECTING_ACTION
	


func _input(event: InputEvent):
	match _state:
		State.SELECTING_NODE:
			_handle_node_selection(event)
		State.SELECTING_ACTION:
			_handle_action_selection(event)
		State.RECRUITING:
			_handle_recruiting_selection(event)


func _on_selected_action(_action: Enums.Action):
	match _action:
		Enums.Action.RAID:
			if Globals.used_actions >= Globals.MAX_ACTIONS:
				notification.show_notification(Enums.Notification.DEBUFF_TIRED)
				await notification.acknowledged
			emit_signal(start_battle.get_name(), current_node)
		Enums.Action.RECRUIT:
			recruiting_menu.origin = current_node
			location_menu.set_process_input(false)
			recruiting_menu.set_process_input(true)
			recruiting_menu.show_options(current_node.location.get_for_hire())
			_state = State.RECRUITING
		Enums.Action.REST:
			# TODO: rest animation
			# TODO: consume food proportional to party size
			rest_menu.play()
			await rest_menu.reached_black_screen
			notification.show_notification(Enums.Notification.ON_REST)
			EventBus.emit_signal("rest_party")

func _draw() -> void:
	for node in nodes_container.get_children():
		var _color: Color = Color.YELLOW if node.is_current else Color.WHITE
		for location in (node as MapNode).locations:
			draw_line(node.position, location.global_position - global_position, _color, 3.0)
