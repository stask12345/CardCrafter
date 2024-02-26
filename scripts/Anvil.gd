extends AreaLocation

var duringIroning : bool = false

func _ready():
	actionOnAddingCard = true
	$Button.connect("pressed",openMenu)
	$Ironing/ButtonAnvil.connect("pressed",hit)

func openMenu():
	$AnvilMenu.visible = true
	system.mainWindow.changeNavVisibility(false)
	$Button.visible = false
	$AnvilMenu/Menu.scale = Vector2(0.8,0.8)
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_BOUNCE)
	t.set_ease(Tween.EASE_OUT)
	t.tween_property($AnvilMenu/Menu,"scale",Vector2(1,1),0.3)

func hideAnvilMenu():
	$AnvilMenu.visible = false
	system.mainWindow.changeNavVisibility(true)
	$Button.visible = true

func setUpRecipy(rec):
	$CardSlot.self_modulate = Color(1,1,1,1)
	$CardSlot.visible = true
	
	$ListOfNeededItems.setUpRecipy(rec)
	$ListOfNeededItems.visible = true
	$Button.visible = false

func cardArrived(c):
	$ListOfNeededItems.cardArrived(c)

func resourcesCollected():
	$ListOfNeededItems.visible = false
	$Ironing.visible = true
	duringIroning = true
	var t = get_tree().create_tween()
	t.tween_property($CardSlot,"self_modulate",Color(1,1,1,0),0.3)
	t.tween_callback(func(): $CardSlot.visible = false)

var currentProcessingProgress : float = 0
var canHit = true
func hit():
	if canHit:
		canHit = false
		currentProcessingProgress += 1
		var progress = (float) (currentProcessingProgress / $ListOfNeededItems.choosenRecipy.outputResource[0].processingPowerNeeded)
		$Ironing/AnimationPlayer.play("hit")
		if progress >= 1:
			ironingCompleted()
		await get_tree().create_timer(0.05).timeout
		$Ironing/ProgressBar.updateProgressBar(progress)
		canHit = true

@onready var locationIndicator = get_node("Ironing/LocationIndicator1")
func ironingCompleted():
	var ic = system.createInteractiveCard(self, $ListOfNeededItems.choosenRecipy.outputResource[0])
	ic.global_position = locationIndicator.global_position
	ic.flyToHand()
	currentProcessingProgress = 0
	
	$Button.visible = true
	$Ironing.visible = false
	duringIroning = false

func addingCard(c):
	$ListOfNeededItems.addingCard(c)
