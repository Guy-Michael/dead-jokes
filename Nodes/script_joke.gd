extends Resource
class_name class_joke

@export var lines : Array[class_joke_line]

var activated = false
var current_line_index = 0

#func _to_string():
	#return lines[current_line_index].text
	
func reset_progress():
	current_line_index = 0
func get_line():
	#print("loaded line: " + lines[current_line_index].text)
	return lines[current_line_index]
func next_line():
	current_line_index += 1
	return get_line()
func is_done():
	return current_line_index >= len(lines)-1
func is_activated():
	return activated
func is_trigger_win(action):
	return lines[current_line_index].accepted_action_indexes.has(action)
func send_action(action : globals.Joke_Component):
	if lines[current_line_index].accepted_action_indexes.has(action):
		activated = true
