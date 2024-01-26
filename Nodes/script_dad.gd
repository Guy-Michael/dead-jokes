extends Node2D
class_name class_dad

enum DAD_STATES{
	off,
	joke,
	dead
}

@export var jokes : Array[class_joke]

var current_joke = -1
@onready var my_timer = $timer
@onready var my_textbox = $TextBox
@onready var my_sprite = $sprite
@onready var rnd = RandomNumberGenerator.new()
@onready var state = DAD_STATES.off

func _ready():
	my_timer.start()

func _process(_delta):
	pass
	
func _on_timer_timeout():
	
	match state:
		DAD_STATES.off:
			switch_state(DAD_STATES.joke)
			
		DAD_STATES.joke:
			#progress joke line
			print("progress joke")
			
			if(current_joke.is_done()):
				#end joke
				if(current_joke.is_activated()):
					switch_state(DAD_STATES.off)
				else:
					switch_state(DAD_STATES.dead)
			else:
				#progress lines
				var _line = current_joke.next_line()
				print(_line.text)
				my_textbox.display_text(_line.text)
				my_timer.start(_line.time)
				
		DAD_STATES.dead:
			#do nothing
			print("dead dad stays dead")
	

func switch_state(new_state : DAD_STATES):
	state = new_state
		
	match new_state:
		DAD_STATES.off:
			print("returned to neutral")
			#my_textbox.display_text("")
			var num = rnd.randf_range(2.0, 6.0)
			print("cooldown set to " + str(num))
			my_timer.start(num)
			my_sprite.set_frame(0)
		
		DAD_STATES.joke:
			#start a joke
			print("joke started")
	
			#pick a joke
			current_joke = jokes.pick_random()
			current_joke.reset_progress()
			
			#send the joke to dialogue
			var _line = current_joke.get_line()
			print(_line.text)
			my_textbox.display_text(_line.text)
			
			#logic
			state = DAD_STATES.joke
			print("timer: " + str(_line.time))
			my_timer.start(_line.time)
			my_sprite.set_frame(1)
			
		DAD_STATES.dead:
			print("died")
			my_textbox.display_text("")
			my_sprite.set_frame(2)
			#change sprite

func send_action(_action: globals.Joke_Component):
	current_joke.send_action(_action)
