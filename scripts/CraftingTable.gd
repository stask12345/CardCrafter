extends AreaLocation

@onready var rSlot = $requestingSlot
@onready var rSlotOutput = $requestingSlot2
@export var availableRecipes : Array[recipy]

func _ready():
	$CraftButton.connect("pressed",craft)
	$ButtonRecipyBook.connect("pressed",openBook)

func cardAdded(c = null):
	checkIfCanCraft()

func cardDeleted():
	checkIfCanCraft()

@onready var craftButton = get_node("CraftButton")
func checkIfCanCraft():
	var currentResources = rSlot.getHoldedCards()
	for r in availableRecipes:
		if r.checkValidity(currentResources):
			if !craftButton.visible:
				showCraftButton(true)
			return
	if craftButton.visible:
		showCraftButton(false)

func craft():
	var currentResources = rSlot.getHoldedCards()
	
	for r in availableRecipes:
		if r.checkValidity(currentResources) and rSlotOutput.checkIfFull():
			rSlot.available = false
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
			rSlot.available = true

func updateKnownRecipies(r : recipy):
	if !system.knownRecipies.has(r):
		system.knownRecipies.append(r)
		system.unknownRecipes.erase(r)

func openBook():
	$RecipyBook.openRecipyBook()
	system.mainWindow.changeNavVisibility(false)

var showCraftTween : Tween
func showCraftButton(show):
	if showCraftTween:
		if showCraftTween.is_running():
			print("kill!")
			showCraftTween.kill()
	
	print("startuje",show)
	
	showCraftTween = get_tree().create_tween()
	#t.set_trans(Tween.TRANS_CUBIC)
	showCraftTween.set_ease(Tween.EASE_OUT)
	
	if show:
		$CraftButton.disabled = false
		$CraftButton.modulate = Color(1,1,1,0)
		$CraftButton.visible = true
		showCraftTween.tween_property($CraftButton,"modulate",Color(1,1,1,1),0.2)
	else:
		$CraftButton.disabled = true
		$CraftButton.modulate = Color(1,1,1,1)
		showCraftTween.tween_property($CraftButton,"modulate",Color(1,1,1,0),0.2)
		showCraftTween.tween_callback(func(): $CraftButton.visible = false)
