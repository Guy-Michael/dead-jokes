extends Node2D
class_name class_action_generator

@export var draggable_node: PackedScene
@onready var positions = [$pos1,$pos2,$pos3,$pos4] 

func _ready():
	for p in positions:
		var inst = draggable_node.instantiate()
		add_child(inst)
		inst.set_pos(p.global_position)


func _on_timer_timeout():	#create a new action
	print("")
