extends ColorRect

func _ready():
	modulate = Color(Color.ANTIQUE_WHITE, 0.7)
	
func _process(_delta):
	if(false and globals.is_dragging):
		visible = true
	else:
		visible = false
