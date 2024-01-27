extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $timer
@onready var ninePatch = $ninePatch
@onready var hint_sprite = $hint
@onready var display_speed_mult = 1

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var speed_mult = 1.2
var letter_time = 0.03*speed_mult
var space_time = 0.06*speed_mult
var punc_time = 0.2*speed_mult
@export var sprites_arr : Array[Texture]
signal finished_displaying()

func _ready():
	visible = false

func set_texture(index: int):
	ninePatch.texture = sprites_arr[index]

func display_text(text_to_display: String):
	
	hint_sprite.visible = false
	
	set_texture(0)
	text = text_to_display
	
	visible = text != ""
	
	#await resized
	#custom_minimum_size.x = min(size.x, MAX_WIDTH)
	#
	#if size.x > MAX_WIDTH:
		#label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#await resized
		#await resized
		#custom_minimum_size.y = size.y
	#
	#global_position.x -= size.x/2
	#global_position.y -= size.y + 24; #adjust!
	
	label.text = ""
	letter_index = 0
	_display_letter()
	
func _display_letter():
	
	
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	label.text += text[letter_index]
	#print(label.text)
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punc_time*display_speed_mult)
		" ":
			timer.start(space_time*display_speed_mult)
		_:
			timer.start(letter_time*display_speed_mult)
			
	letter_index += 1	
	
func _on_timer_timeout():
	_display_letter()

func display_hint():
	hint_sprite.visible = true
