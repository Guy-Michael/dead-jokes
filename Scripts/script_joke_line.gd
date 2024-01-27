extends Resource
class_name class_joke_line

@export var text = ""
@export var time = 4.0
@export var is_activator: bool

func get_activator():
	return is_activator
