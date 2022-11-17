extends Sprite2D
class_name RandomSpriteFrame2D

func _ready():
	randomize()
	frame = randi_range(0, hframes * vframes - 1)
