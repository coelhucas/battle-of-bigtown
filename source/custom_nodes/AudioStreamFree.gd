extends RandomPitchAudioStreamPlayer
class_name AudioStreamFree

func _ready():
	connect(finished.get_name(), queue_free)
