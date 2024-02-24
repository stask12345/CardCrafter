extends Control
class_name interactiveCard

@export var cardData : card
@onready var system = get_node("/root/MainScene")
var toPick = false #if true, card after clicking will return to hand
var goingToFinishGoal = false #if true, card after flyToPoint, will raise burnCard function in parent(requesting field)
var flying = false
var unordering = false

func _ready():
	if cardData.image:
		$Center/Item.texture = cardData.image
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
	if flyTween:
		if flyTween.is_running():
			flyTween.kill()
	
	flying = true
	#var t = get_tree().create_tween()
	#t.set_trans(Tween.TRANS_QUINT)
	#t.set_ease(Tween.EASE_IN)
	
	flyTween = get_tree().create_tween()
	flyTween.set_trans(Tween.TRANS_QUINT)
	flyTween.set_ease(Tween.EASE_IN)
	
	var goalPoint = Vector2(global_position.x,810)
	
	var time
	if !fast:
		time = 0.7
	else:
		flyTween.set_trans(Tween.TRANS_CUBIC)
		time = 0.4
	flyTween.tween_property(self,"global_position",goalPoint, time)
	flyTween.parallel().tween_property(self,"scale",Vector2(0.6,0.5),time)
	flyTween.parallel().tween_property(self,"modulate",Color(1,1,1,0.3), time)
	flyTween.tween_callback(addCardToHand)

var addingToLocation = false
var flyTween : Tween = null
func flyToPoint(goalPoint):
	if flyTween:
		if flyTween.is_running():
			flyTween.kill()
	flyTween = get_tree().create_tween()
	flyTween.set_trans(Tween.TRANS_CUBIC)
	flyTween.set_ease(Tween.EASE_OUT)
	
	goalPoint = goalPoint - global_position + position
	
	flyTween.tween_property(self,"position",goalPoint, 0.7)
	flyTween.tween_callback(func(): flying = false)
	if goingToFinishGoal:
		flyTween.tween_callback(func(): get_parent().cardArrivedAtGoal(self))
	if addingToLocation and get_parent():
		flying = true
		addingToLocation = false
		flyTween.tween_callback(func(): 
			get_parent().parentArea.cardAdded(self.cardData))

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

func cardDestroyerAnimation():
	var t = get_tree().create_tween()
	#t.set_trans(Tween.TRANS_CUBIC)
	#t.set_ease(Tween.EASE_OUT)
	
	t.tween_property(self,"global_position:y", global_position.y + 150, 2.2)
	t.tween_callback(endCardDestroyerAnimaction)
	cardDestroyerAnimationRotation(1)

func cardDestroyerAnimationRotation(direction):
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	#t.set_ease(Tween.EASE_OUT)
	
	t.tween_property(self,"rotation_degrees", 0 + (5*direction), 0.3)
	t.tween_callback(func(): cardDestroyerAnimationRotation(direction * -1))

func endCardDestroyerAnimaction():
	get_parent().parentArea.endAnimation(cardData)
	queue_free()

func playDestroyAnim():
	$AnimationPlayer.play("destro")

#func newCardAnimation():
	#modulate.a = 0.3
	#var t = get_tree().create_tween()
	#t.set_trans(Tween.TRANS_QUINT)
	#t.set_ease(Tween.EASE_IN)
	#
	#t.tween_property(self,"modulate:a",1,0.5)
