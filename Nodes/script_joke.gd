extends Resource
class_name class_joke

@export var lines : Array[class_joke_line]

enum JOKE_STATES{
	unanswered,
	won,
	lost,
}
var state = JOKE_STATES.unanswered
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
	return state == JOKE_STATES.won
func is_trigger_win(action):
	return lines[current_line_index].accepted_action_indexes.has(action)
func send_action(action : globals.Joke_Component):
	
	#abort if already answered
	if(state != JOKE_STATES.unanswered):
		return
	
	if lines[current_line_index].accepted_indexes.has(action):
		state = JOKE_STATES.won
	else:
		state = JOKE_STATES.lost
		
	print("activated: " + str(state) + ". accepted: " + str(lines[current_line_index].accepted_indexes))
