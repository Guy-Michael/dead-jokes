extends Resource
class_name class_joke_line

@export var text = ""
@export var time = 2.0
@export var accepted_indexes : Array[globals.ACTIONS]

func get_activator():
	return len(accepted_indexes) > 0
