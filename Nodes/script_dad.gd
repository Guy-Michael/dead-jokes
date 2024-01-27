#@tool
extends Node2D
class_name class_dad

enum DAD_STATES{
	off,
	joke,
	dead
}
enum SFX{
	joke,
	win,
	death,
}
@export var jokes : Array[class_joke]
@export var cooldown_min = 2.0
@export var cooldown_max = 5.0
@export var textbox_pos: Vector2 = Vector2(1,1)
@export var my_clap_drag: Node

@export_group("sounds")
@export var joke_sfxs: Array[Resource]
@export var win_sfxs: Array[Resource]
@export var death_sfxs: Array[Resource]

var current_joke = -1
@onready var my_timer = $timer
@onready var my_textbox = $TextBox
@onready var my_sprite = $sprite
@onready var sfx_player = $sfx_player
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
				if(_line.get_activator() and globals.hint_active):
					my_textbox.display_hint()
				my_timer.start(_line.time)
				
		DAD_STATES.dead:
			#do nothing
			print("dead dad stays dead")


func switch_state(new_state : DAD_STATES):
	state = new_state
		
	match new_state:
		DAD_STATES.off:
			my_textbox.display_text("")
			var num = rnd.randf_range(2.0, 6.0)
			my_timer.start(num)
			my_sprite.set_frame(0)
			current_joke = -1
			
			#disable hint
			globals.hint_active = false
		
		DAD_STATES.joke:
			#start a joke
			play_sfx(SFX.joke)
	
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
			play_sfx(SFX.death)
			my_textbox.display_text("")
			
			#change sprite
			my_sprite.set_frame(2)
			
			#stop ost
			globals.hp -= 1
			if(globals.hp == 0):
				%ost_source.stop()
			
			#destroy clap
			my_clap_drag.queue_free()

func send_action(_action: globals.ACTIONS):
	
	if(state == DAD_STATES.joke):
		current_joke.send_action(_action)
		var _right = current_joke.is_activated()
		
		if _right:
			play_sfx(SFX.win)
			my_textbox.set_texture(1)
			globals.hint_active = false
		else:
			#if globals.hint_active:
				#my_textbox.set_texture(2)
			#else:
			switch_state(DAD_STATES.dead)
			3
		return _right
	return true
	
func play_sfx(index: SFX):
	var arr = []
	match index:
		SFX.death:
			arr = death_sfxs
		SFX.joke:
			arr = joke_sfxs
		SFX.win:
			arr = win_sfxs
	sfx_player.stream = arr.pick_random()
	sfx_player.play()
