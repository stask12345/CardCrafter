extends Control
class_name mainWindowSystem

var areaIndex = 1
@export var howMuchEmptyLocations : Array[int]
@export var rankBuildingsArray : Array[Array]
@onready var system = get_node("/root/MainScene")

func _ready():
	$NavArrows/ArrowRight/Button.connect("pressed",func(): moveWindow(1))
	$NavArrows/ArrowLeft/Button.connect("pressed",func(): moveWindow(-1))
	updateNumberOfNavCircles()

var moveTween : Tween
func moveWindow(direction):
	areaIndex += direction
	if areaIndex < 0:
		areaIndex = 0
		return
	if areaIndex >= get_children().size()-1:
		areaIndex = get_children().size()-2
		return
	
	for i in get_child_count():
		if get_child(i) is AreaLocation:
			if areaIndex != i and (areaIndex - direction) != i:
				get_child(i).visible = false 
	
	checkArrowVis()
	
	var previousArea = get_child(areaIndex - direction)
	var nextArea = get_child(areaIndex)
	
	var previousAreaGoal
	if direction == 1:
		nextArea.global_position = Vector2(750,0)
		previousAreaGoal = Vector2(-750,0)
	else:
		nextArea.global_position = Vector2(-750,0)
		previousAreaGoal = Vector2(750,0)
	
	if moveTween:
		if moveTween.is_running():
			updateNavigationCircles()
			moveTween.kill()
	moveTween = create_tween()
	moveTween.set_trans(Tween.TRANS_CUBIC)
	moveTween.set_ease(Tween.EASE_OUT)
	
	nextArea.visible = true
	moveTween.tween_property(nextArea,"global_position:x",0,0.3)
	moveTween.parallel().tween_property(previousArea,"global_position",previousAreaGoal,0.3)
	moveTween.tween_callback(func(): afterAreaChanged(previousArea))

func afterAreaChanged(previousArea):
	for i in get_child_count():
		if get_child(i) is AreaLocation:
			if areaIndex != i:
				get_child(i).visible = false 
	previousArea.visible = false
	updateNavigationCircles()

func checkArrowVis():
	if areaIndex == 0:
		$NavArrows/ArrowLeft.visible = false
	else:
		$NavArrows/ArrowLeft.visible = true
	if areaIndex == get_children().size()-2:
		$NavArrows/ArrowRight.visible = false
	else:
		$NavArrows/ArrowRight.visible = true

@onready var navigation = get_node("NavArrows/Navigation/HBoxContainer")
func updateNumberOfNavCircles():
	while navigation.get_child_count() < get_child_count()-1:
		var newCircle = navigation.get_child(0).duplicate()
		newCircle.get_child(0).frame = 0
		navigation.add_child(newCircle)

func changeNavVisibility(v):
	if v:
		$NavArrows.visible = true
	else:
		$NavArrows.visible = false

func updateNavigationCircles():
	for n in navigation.get_children():
		n.get_child(0).frame = 0
	navigation.get_child(areaIndex).get_child(0).frame = 1

func addNewLocation(locationInstance : PackedScene, vis = false):
	var location = locationInstance.instantiate()
	add_child(location)
	move_child(location,get_child_count()-2)
	location.visible = vis

const numberOfStartingLocations = 5
func addNewEmptyLocation():
	print(howMuchEmptyLocations)
	print(get_child_count())
	if get_child(get_child_count()-2).name != "EmptyLocation":
		if get_child_count() - numberOfStartingLocations < howMuchEmptyLocations[system.rank]:
			var emptyLocationInstance : PackedScene = load("res://objects/AreaLocations/EmptyLocation.tscn")
			var emptyLocation = emptyLocationInstance.instantiate()
			add_child(emptyLocation)
			move_child(emptyLocation,get_child_count()-2)
			emptyLocation.visible = false
			checkArrowVis()
			await get_tree().create_timer(1).timeout
			updateNumberOfNavCircles()
