#@tool
extends Node2D
class_name class_dad

enum DAD_STATES{
	off,
	joke,
	dead,
	tutorial
}
enum SFX{
	joke,
	win,
	death,
}

@export_group("jokes")
@export var jokes : Array[class_joke]
@export var tutorial_joke: class_joke

@export var cooldown_min = 2.0
@export var cooldown_max = 5.0
@export var textbox_pos: Vector2 = Vector2(1,1)
@export var my_clap_drag: Node
@export var time_mult: float
@export var is_tutorial: bool

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
@onready var acc_rate = 0.85

func _ready():
	#my_timer.start(rnd.randf_range(cooldown_min,cooldown_max))
	if(is_tutorial):
		switch_state(DAD_STATES.tutorial)

func _process(_delta):
	if Engine.is_editor_hint():
		my_textbox.global_position = Vector2(textbox_pos)
	
	if Input.is_action_just_released("reset"):
		get_tree().reload_current_scene()

func _on_timer_timeout():
	
	match state:
		DAD_STATES.off:
			switch_state(DAD_STATES.joke)
			
		DAD_STATES.joke:
			#progress joke line
			if(current_joke.is_done() or current_joke.is_activated()):
				#end joke
				if(current_joke.is_activated()):
					if(is_tutorial):
						get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
					else:
						switch_state(DAD_STATES.off)
				else:
					switch_state(DAD_STATES.dead)
			else:
				#progress lines
				var _line = current_joke.next_line()
				my_textbox.display_text(_line.text)
				if(_line.get_activator() and globals.hint_active):
					my_textbox.display_hint()
				my_timer.start(_line.time*time_mult)
				
		DAD_STATES.dead:
			#do nothing
			print("dead dad stays dead")
		
		DAD_STATES.tutorial:
			switch_state(DAD_STATES.tutorial)

func switch_state(new_state : DAD_STATES):
	state = new_state
	
	match new_state:
		DAD_STATES.off:
			my_textbox.display_text("")
			var num = rnd.randf_range(cooldown_min*time_mult, cooldown_max*time_mult)
			my_timer.start(num*time_mult)
			my_sprite.set_frame(0)
			current_joke = -1
			time_mult *= acc_rate
			my_textbox.display_speed_mult = time_mult*1.1
			
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
			
		DAD_STATES.tutorial:
			#start a joke
			play_sfx(SFX.joke)
	
			#pick a joke
			current_joke = tutorial_joke
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
