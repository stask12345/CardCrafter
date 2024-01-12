extends Control
class_name interactiveCard

@export var cardData : card
@onready var system = get_node("/root/MainScene")
var toPick = false #if true, card after clicking will return to hand
var goingToFinishGoal = false #if true, card after flyToPoint, will raise burnCard function in parent(requesting field)
var flying = false

func _ready():
	$Background/Item.texture = cardData.image
	$Name.text = cardData.cardName
	$Button.connect("pressed",cardClicked)

func openPackageAnimation(centerPoint):
	var t = create_tween()
	t.set_trans(Tween.TRANS_QUART)
	t.set_ease(Tween.EASE_OUT)
	
	var goalPoint = centerPoint.direction_to(global_position)
	var distance = goalPoint * (50 + randi()%100)
	
	t.tween_property(self,"global_position",global_position + distance, 1)
	t.tween_callback(flyToHand)

func flyToHand(fast = false):
	flying = true
	var t = create_tween()
	t.set_trans(Tween.TRANS_QUINT)
	t.set_ease(Tween.EASE_IN)
	
	var goalPoint = Vector2(global_position.x,810)
	
	var time
	if !fast:
		time = 0.7
	else:
		t.set_trans(Tween.TRANS_CUBIC)
		time = 0.4
	t.tween_property(self,"global_position",goalPoint, time)
	t.parallel().tween_property(self,"scale",Vector2(0.6,0.6),time)
	t.parallel().tween_property(self,"modulate",Color(1,1,1,0.5), time)
	t.tween_callback(addCardToHand)

var addingToLocation = false
func flyToPoint(goalPoint):
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	
	t.tween_property(self,"global_position",goalPoint, 0.7)
	t.tween_callback(func(): flying = false)
	if goingToFinishGoal:
		t.tween_callback(func(): get_parent().cardArrivedAtGoal(self))
	if addingToLocation:
		flying = true
		addingToLocation = false
		t.tween_callback(func(): 
			get_parent().parentArea.cardAdded())

func addCardToHand():
	system.addCard(cardData)
	queue_free()

func cardClicked():
	if !flying:
		if toPick:
			flyToHand()
			toPick = false
		else:
			returnFromRequesting()

func returnFromRequesting():
	if get_parent().is_in_group("requesting") and !goingToFinishGoal:
		var reqParent = get_parent().parentArea
		
		var pos = global_position
		get_parent().deleteCard(self)
		system.add_child(self)
		global_position = pos
		reqParent.cardDeleted()
		flyToHand(true)
