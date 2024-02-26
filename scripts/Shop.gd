extends AreaLocation

@export var recipyCost : Array[float]
@export var systemUpgradeCost : Array[float]
@export var currentRecipyIndex : int = 0
@export var currentSystemIndex : int = 0
@export var systemUpgradeNames : Array[String]

func _ready():
	call_deferred("updateCostLabels")
	$RecipyUpgrade/Button.connect("pressed",buyRecipy)
	$SystemUpgrade/Button.connect("pressed",buySystemUpgrade)
	$Blueprint/ExitButton.connect("pressed",exitBluePrint)

func exchageCardIntoCoins(cardData : card):
	var listOfCoins = []
	var coinValue = cardData.value
	
	while coinValue > 10:
		coinValue -= 10
		listOfCoins.append(10)
	
	while coinValue > 5:
		coinValue -= 5
		listOfCoins.append(5)
	
	while coinValue >= 1:
		coinValue -= 1
		listOfCoins.append(1)
	
	return listOfCoins

func cardArrived(c):
	c.z_index = -10
	c.cardDestroyerAnimation()
	$Shop/AnimationPlayer.play("idle")

func endAnimation(c : card):
	monetizeCard(c)
	if $requestingSlot.get_child_count() == 2:
		$Shop/cardDestroyer.rotation_degrees = 0
		$Shop/AnimationPlayer.stop()

var coinObject = preload("res://objects/Utility/Coin.tscn")
@onready var markerPosition : Vector2 = $PositionMarker.global_position
func monetizeCard(c : card):
	var listOfCoins = exchageCardIntoCoins(c)
	for l in listOfCoins:
		var coin = coinObject.instantiate()
		coin.value = l
		coin.global_position = markerPosition
		coin.global_position.x += 45
		coin.global_position.x -= randi()%90
		add_child(coin)
		var strength = 2
		var x = coin.global_position.x + ((coin.global_position.x - markerPosition.x) * strength)
		var y = coin.global_position.y + 50 + randi()%50
		coin.flyToPoint(Vector2(x,y),true)

func updateCostLabels():
	$RecipyUpgrade/Cost.text = str(system.moneySystemNode.returnCoinNumber(recipyCost[currentRecipyIndex]))
	$RecipyUpgrade/Cost/Icon.texture = system.moneySystemNode.returnCoinGraphics(recipyCost[currentRecipyIndex])
	
	$SystemUpgrade/Cost.text = str(system.moneySystemNode.returnCoinNumber(systemUpgradeCost[currentSystemIndex]))
	$SystemUpgrade/Cost/Icon.texture = system.moneySystemNode.returnCoinGraphics(systemUpgradeCost[currentSystemIndex])

func buySystemUpgrade():
	if system.moneySystemNode.money >= systemUpgradeCost[currentSystemIndex]:
		system.moneySystemNode.spendMoney(systemUpgradeCost[currentSystemIndex])
		currentSystemIndex += 1
		system.systemUpgradeRank += 1
		updateCostLabels()
		
		system.mainWindow.changeNavVisibility(false)
		$Blueprint/PopupName.text = "Unlocked new feature!"
		$Blueprint/SystemUpgrade/Name.text = ""
		$Blueprint/SystemUpgrade/Image.texture = ""
		$Blueprint/SystemUpgrade.visible = true
		openBlueprintAnimation(true)
		await get_tree().create_timer(1).timeout
		_canExitBlueprint = true

var _canExitBlueprint = false
func buyRecipy():
	if system.unknownRecipes.size() > 0:
		if system.moneySystemNode.money >= recipyCost[currentRecipyIndex]:
			system.moneySystemNode.spendMoney(recipyCost[currentRecipyIndex])
			var newRecipy = system.unknownRecipes[0]
			system.craftingTable.updateKnownRecipies(newRecipy)
			currentRecipyIndex += 1
			updateCostLabels()
			
			system.mainWindow.changeNavVisibility(false)
			$Blueprint/PopupName.text = "Unlocked new recipy!"
			for ch in $Blueprint/Recipy/RecipyListItem/CenterContainer/HBoxContainer.get_children():
				ch.queue_free()
			$Blueprint/Recipy/RecipyListItem.setUpRecipy(newRecipy,0,true)
			$Blueprint/Recipy.visible = true
			$Blueprint.visible = true
			openBlueprintAnimation(true)
			await get_tree().create_timer(1).timeout
			_canExitBlueprint = true
		else:
			print("Not enought money!") #TODO

func openBlueprintAnimation(vis):
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	
	var goal = Color(1,1,1,0)
	if vis:
		$Blueprint.scale = Vector2(0.8,0.8)
		$Blueprint.modulate = Color(1,1,1,0)
		goal = Color(1,1,1,1)
	else:
		goal = Color(1,1,1,0)
	
	t.tween_property($Blueprint,"modulate",goal,1)
	if vis:
		t.set_trans(Tween.TRANS_BOUNCE)
		t.parallel().tween_property($Blueprint,"scale",Vector2(1,1),1)

func exitBluePrint():
	if _canExitBlueprint:
		_canExitBlueprint = false
		$Blueprint/Recipy.visible = false
		system.mainWindow.changeNavVisibility(true)
		openBlueprintAnimation(false)
		await get_tree().create_timer(1).timeout
		$Blueprint.visible = false
