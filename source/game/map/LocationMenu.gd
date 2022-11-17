extends MarginContainer

signal selected_action(action)

@onready var available_actions_container := $CenterContainer/Information/AvailableActions
@onready var label_name := $CenterContainer/Information/PlaceName
@onready var label_description := $CenterContainer/Information/PlaceDescription

@onready var btn_rest: ActionButton = $CenterContainer/Information/AvailableActions/Rest
@onready var btn_raid: ActionButton = $CenterContainer/Information/AvailableActions/Raid
@onready var btn_recruit: ActionButton = $CenterContainer/Information/AvailableActions/Recruit

var _focused_option: ActionButton
var _used_actions: int = 0

func _ready() -> void:
	hide()
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	set_process_input(false)
	EventBus.connect("update_actions", func(_actions: int):
		_used_actions = _actions
	)


func focus_option():
	for _option_btn in available_actions_container.get_children():
		if _option_btn.visible:
			_option_btn.grab_focus()
			_focused_option = _option_btn
			break


func _input(event: InputEvent):
	if event.is_action_pressed("action_1") and not _focused_option.disabled:
		emit_signal(selected_action.get_name(), _focused_option.action)

func _on_focus_changed(_control: Control):
	if _control is Button and _control in available_actions_container.get_children():
		_focused_option = _control

func display(_location: GameLocation):
	label_name.text = _location.name
	label_description.text = _location.description
	
	for _button in available_actions_container.get_children():
		_button.visible = (_button as ActionButton).action in _location.available_actions
		btn_rest.disabled = _location.hostile and not _location.just_fighted
		btn_recruit.disabled = _location.just_fighted
		btn_raid.disabled = _location.just_fighted
