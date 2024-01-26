extends Sprite2D
class_name class_dad

enum DAD_STATES{
	off,
	joke,
	dead
}

@export var jokes : Array[class_joke] = []

var current_joke = -1
@onready var my_timer = $timer
@onready var my_textbox = $TextBox
@onready var rnd = RandomNumberGenerator.new()
@onready var state = DAD_STATES.off

func _ready():
	print("start")
	my_timer.start()

func _process(_delta):
	pass
	
func _on_timer_timeout():
	
	match state:
		DAD_STATES.off:
			#start a joke
			current_joke = jokes.pick_random();
			
			my_textbox.display_text(jokes.pick_random())
			state = DAD_STATES.joke
			print("joke started")
		DAD_STATES.joke:
			#progress joke line
			print("progress joke")
		DAD_STATES.dead:
			#do nothing
			print("dead dad stays dead")
	
	var num = rnd.randf_range(2.0, 6.0)
	print("stopped and set to " + str(num))
	my_timer.wait_time = num
	my_timer.start()
