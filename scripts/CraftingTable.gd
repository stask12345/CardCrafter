extends AreaLocation

@onready var rSlot = $requestingSlot
@onready var rSlotOutput = $requestingSlot2
@export var availableRecipes : Array[recipy]
#TODO In future add highlighting of craft button, based on functions in AreaLocation class
func _ready():
	$CraftButton.connect("pressed",craft)
	$ButtonRecipyBook.connect("pressed",openBook)

func cardAdded(c = null):
	var currentResources = rSlot.getHoldedCards()
	for r in availableRecipes:
		if r.checkValidity(currentResources):
			if !$CraftButton.visible:
				showCraftButton(true)
			return true
	return false

func cardDeleted():
	if !cardAdded():
		showCraftButton(false)

func craft():
	var currentResources = rSlot.getHoldedCards()
	
	for r in availableRecipes:
		if r.checkValidity(currentResources) and rSlotOutput.checkIfFull():
			updateKnownRecipies(r)
			
			$Clouds/AnimationPlayer.play("idle")
			for c in rSlot.get_children():
				if c is interactiveCard:
					c.flyToPoint(rSlot.global_position)
			showCraftButton(false)
			await get_tree().create_timer(1).timeout
			rSlot.deleteAllCards()
			var intCard = system.createInteractiveCard(self,r.outputResource[0])
			intCard.global_position = rSlot.global_position
			await get_tree().create_timer(1).timeout
			
			rSlotOutput.addCard(intCard)
			intCard.toPick = true

func updateKnownRecipies(r : recipy):
	if !system.knownRecipies.has(r):
		system.knownRecipies.append(r)
		print(system.knownRecipies)

func openBook():
	$RecipyBook.openRecipyBook()

func showCraftButton(show):
	var t = get_tree().create_tween()
	#t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_OUT)
	
	if show:
		$CraftButton.modulate = Color(1,1,1,0)
		$CraftButton.visible = true
		t.tween_property($CraftButton,"modulate",Color(1,1,1,1),0.2)
	else:
		$CraftButton.modulate = Color(1,1,1,1)
		t.tween_property($CraftButton,"modulate",Color(1,1,1,0),0.2)
		t.tween_callback(func(): $CraftButton.visible = false)
