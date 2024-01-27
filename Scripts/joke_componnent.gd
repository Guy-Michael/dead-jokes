extends Node2D

var draggable = false	#Is the object is draggable
var is_inside_dropable = false	#Is the object in a dropabale area
var body_ref	#Refrence to the dropable area when the object enters it
var dropped_on	#the dad iv dropped on
var offset: Vector2		#For maintaing the position of the object relative to the mouse pos
@onready var initial_pos: Vector2 = global_position		#Keeps the inital position of the object
@export var component_type: globals.ACTIONS 
@export var hover_scale: float
@export var normal_scale: float

func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			#initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			globals.is_dragging = true
		
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			globals.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				print("dropped!")
				dropped_on.send_action(component_type)
				#var t = Tween.new()
				#t.tween_property(self, "scale", Vector2(0,0), 0.2).set_ease(Tween.EASE_OUT)		
				#t.finished.connect(destroy_me)
				destroy_me()
			else:
				#global_position = initial_pos
				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)
func _on_area_2d_mouse_entered():
	#Making sure we are dragging only one object
	#print_debug("mouse entered")
	if not globals.is_dragging:
		draggable = true
		scale = Vector2(hover_scale, hover_scale)		#Scaling the sprite (more for the visual effect)
		
func _on_area_2d_mouse_exited():
	if not globals.is_dragging:
		draggable = false
		scale = Vector2(normal_scale, normal_scale)		#Scaling the sprite (more for the visual effect)
		
func _on_area_2d_body_entered(body:StaticBody2D):
	print("entered  area")
	if body.is_in_group('droppable'):		#TODO:Create the 'dropable' group and than add the drop areas to the group
		is_inside_dropable = true
		body_ref = body
		dropped_on = body.get_parent().get_parent()
		
func _on_area_2d_body_exited(body):
	if body.is_in_group('droppable'):
		is_inside_dropable = false

##Retruns the type of the joke component
func return_type():
	return component_type

##Destroy the object when it is dropped in dropable area
func destroy_me():
	queue_free()
