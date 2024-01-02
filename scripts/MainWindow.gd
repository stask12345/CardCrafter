extends Control

var areaIndex = 0

func _ready():
	$NavArrows/ArrowRight/Button.connect("pressed",func(): moveWindow(1))
	$NavArrows/ArrowLeft/Button.connect("pressed",func(): moveWindow(-1))

func moveWindow(direction):
	areaIndex += direction
	if areaIndex < 0:
		areaIndex = 0
		return
	if areaIndex >= get_children().size() - 1:
		areaIndex = get_children().size()-2
		return
	
	var previousArea = get_child(areaIndex - direction)
	var nextArea = get_child(areaIndex)
	
	var previousAreaGoal
	if direction == 1:
		nextArea.global_position = Vector2(750,0)
		previousAreaGoal = Vector2(-750,0)
	else:
		nextArea.global_position = Vector2(-750,0)
		previousAreaGoal = Vector2(750,0)
	
	var t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	
	nextArea.visible = true
	t.tween_property(nextArea,"global_position:x",0,0.3)
	t.parallel().tween_property(previousArea,"global_position",previousAreaGoal,0.3)
	t.tween_callback(func(): afterAreaChanged(previousArea))

func afterAreaChanged(previousArea):
	previousArea.visible = false
	updateNavigationCircles()

func changeNavVisibility(v):
	if v:
		$NavArrows.visible = true
	else:
		$NavArrows.visible = false

func updateNavigationCircles():
	for n in $NavArrows/Navigation/HBoxContainer.get_children():
		n.get_child(0).frame = 0
	$NavArrows/Navigation/HBoxContainer.get_child(areaIndex).get_child(0).frame = 1
