@tool
extends Node2D
class_name class_dad

enum DAD_STATES{
	off,
	joke,
	dead
}

@export var jokes : Array[class_joke]
@export var cooldown_min = 2.0
@export var cooldown_max = 5.0
@export var textbox_pos: Vector2 = Vector2(1,1)

var current_joke = -1
@onready var my_timer = $timer
@onready var my_textbox = $TextBox
@onready var my_sprite = $sprite
@onready var death_sfx_source = $sfx_dead
@onready var win_sfx_source = $sfx_win
@onready var joke_sfx_source = $sfx_joke
@onready var rnd = RandomNumberGenerator.new()
@onready var state = DAD_STATES.off

func _ready():
	my_timer.start(rnd.randf_range(cooldown_min,cooldown_max))
#
func _process(_delta):
	if Engine.is_editor_hint():
		my_textbox.global_position = Vector2(textbox_pos)


		
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
			win_sfx_source.play()
			my_textbox.display_text("")
			var num = rnd.randf_range(2.0, 6.0)
			my_timer.start(num)
			my_sprite.set_frame(0)
			current_joke = -1
		
		DAD_STATES.joke:
			#start a joke
			print("joke started")
			joke_sfx_source.play()
	
			#pick a joke
			current_joke = jokes.pick_random()
			current_joke.reset_progress()
			
			#send the joke to dialogue
			var _line = current_joke.get_line()
			my_textbox.display_text(_line.text)
			#my_textbox.global_position = textbox_pos #done before already but buggy for some reason
			
			#logic
			state = DAD_STATES.joke
			my_timer.start(_line.time)
			my_sprite.set_frame(1)
			
		DAD_STATES.dead:
			print("died")
			death_sfx_source.play()
			my_textbox.display_text("")
			my_sprite.set_frame(2)
			#change sprite

func send_action(_action: globals.ACTIONS):
	
	if(state == DAD_STATES.joke):
		current_joke.send_action(_action)
		var _right = current_joke.is_activated()
		
		if _right:
			my_textbox.set_texture(1)
		else:
			switch_state(DAD_STATES.dead)
