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
	state = JOKE_STATES.unanswered
func get_line():
	#print("loaded line: " + lines[current_line_index].text)
	return lines[current_line_index]
func next_line():
	current_line_index += 1
	return get_line()
func is_done():
	return current_line_index >= len(lines)-1
func is_activated():
	print("activated? " + str(state == JOKE_STATES.won))
	return state == JOKE_STATES.won
func send_action(action : globals.ACTIONS):
	
	#abort if already answered
	if(state != JOKE_STATES.unanswered):
		return
	
	if len(lines[current_line_index].accepted_indexes)>0 or lines[current_line_index].accepted_indexes.has(action):
		state = JOKE_STATES.won
	else:
		state = JOKE_STATES.lost
		
	print("activated: " + str(state) + ". accepted: " + str(lines[current_line_index].accepted_indexes))
