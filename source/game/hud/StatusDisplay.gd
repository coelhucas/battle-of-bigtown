extends HBoxContainer

@onready var label_gold := $Gold
@onready var label_actions := $Actions
@onready var label_population := $Population
@onready var label_food := $FoodValue

func _ready() -> void:
	label_food.text = "%s/%s" % [Globals.food, Globals.FOOD_PER_UNIT * Globals.population]
	EventBus.connect(EventBus.update_actions.get_name(), _on_updated_actions)
	EventBus.connect(EventBus.update_gold.get_name(), _on_updated_gold)
	EventBus.connect(EventBus.update_population.get_name(), _on_updated_population)
	EventBus.connect(EventBus.updated_food.get_name(), func():
		label_food.text = "%s/%s" % [Globals.food, Globals.FOOD_PER_UNIT * Globals.population]
	)


func update_initials(actions, gold, population):
	_on_updated_actions(actions)
	_on_updated_gold(gold)
	_on_updated_population(population)

func _on_updated_actions(_actions: int):
	label_actions.text = "%s/%s" % [str(_actions), str(Globals.MAX_ACTIONS)]
	
func _on_updated_gold(_gold: int):
	label_gold.text = str(_gold)

func _on_updated_population(_population):
	label_population.text = str(_population)
