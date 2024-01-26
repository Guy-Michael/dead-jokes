extends Resource
class_name class_joke

@export var lines : Array[class_joke_line] = []

var current_line_index = 0;

func get_line():
	return lines[current_line_index]
func next_line():
	current_line_index += 1
func is_trigger_win(action):
	return lines[current_line_index].accepted_action_indexes.has(action)
