extends Node2D

var draggable = false	#Is the object is draggable
var is_inside_dropable = false	#Is the object in a dropabale area
var body_ref	#Refrence to the dropable area when the object enters it
var offset: Vector2		#For maintaing the position of the object relative to the mouse pos
var inital_pos: Vector2		#Keeps the inital position of the object
@export var component_type: globals.Joke_Component 

func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			inital_pos = global_position
			offset = get_global_mouse_position() - global_position
			globals.is_dragging = true
		
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			globals.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				var t = Tween.new()
				t.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)		
				t.finished.connect(destroy_me)
			else:
				tween.tween_property(self, "position", inital_pos, 0.2).set_ease(Tween.EASE_OUT)
func _on_area_2d_mouse_entered():
	#Making sure we are dragging only one object
	if not globals.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)		#Scaling the sprite (more for the visual effect)
		
func _on_area_2d_mouse_exited():
	if not globals.is_dragging:
		draggable = false
		scale = Vector2(1, 1)
		
func _on_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group('dropable'):		#TODO:Create the 'dropable' group and than add the drop areas to the group
		is_inside_dropable = true
		body_ref = body
		
		
func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = false

##Retruns the type of the joke component
func return_type():
	return component_type

##Destroy the object when it is dropped in dropable area
func destroy_me():
	queue_free()
