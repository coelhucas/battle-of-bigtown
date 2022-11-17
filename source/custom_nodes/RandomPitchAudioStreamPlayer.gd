extends AudioStreamPlayer
class_name RandomPitchAudioStreamPlayer


func play(from_position: float = 0.0) -> void:
	randomize()
	pitch_scale = randf_range(0.85, 1.15)
	super()
	pass
