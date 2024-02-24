extends Sprite2D

@export var colorChange : bool = true
@export var barColor : Color

func _ready():
	$Progress.self_modulate = barColor

func updateProgressBar(progress):
	var col : Color
	if colorChange:
		if progress < 0.3:
			col = Color(0.9,0.4,0.4)
		else:
			if progress < 0.7:
				col = Color("#ddcd00")
			else:
				col = Color(0.4,0.9,0.4)
	
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	
	if colorChange:
		t.tween_property($Progress,"self_modulate",col,0.3)
	t.parallel().tween_property($Progress,"scale:x",progress,0.3)
