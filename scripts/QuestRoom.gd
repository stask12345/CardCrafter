extends AreaLocation

@export var rankRecipies : Array[recipy]
@export var rankNames : Array[String]
@export var rankGoldRewards : Array[int]
@onready var container = $CenterContainer/GridContainer

func _ready():
	showCardsNeededForRankUp()
	showRankLabel()
	call_deferred("showRewards")
	$RankUpButton.connect("pressed",rankUp)
	
	call_deferred("debug")

func debug(): #TODELETE
	system.addCard(load("res://resources/cards/Forest/FirePlace.tres"))
	system.addCard(load("res://resources/cards/Forest/FirePlace.tres"))
	system.addCard(load("res://resources/cards/Forest/Vase.tres"))
	system.addCard(load("res://resources/cards/Mine/IronBar.tres"))

@onready var cardPlaceholder = preload("res://objects/Utility/PlaceHolderCard.tscn")
func showCardsNeededForRankUp():
	for ch in container.get_children():
		ch.queue_free()
	
	for r in rankRecipies[system.rank].resources:
		var cp = cardPlaceholder.instantiate()
		cp.cardData = r
		container.add_child(cp)
		cp.get_node("requestingSlot").parentArea = self
		cp.get_node("requestingSlot").whiteList.append(r)

func showRankLabel():
	$Rank.text = "Rank " + str(system.rank)
	$RankDescription.text = rankNames[system.rank]

func cardAdded(c = null):
	checkCardsForRankingUp()

func cardDeleted():
	checkCardsForRankingUp()

func checkCardsForRankingUp():
	var rSlots = container.get_children()
	var listOfRes = []
	for r in rSlots:
		var rs = r.get_node("requestingSlot")
		listOfRes.append_array(rs.getHoldedCards())
	
	if rankRecipies[system.rank].checkValidity(listOfRes):
		$RankUpButton.visible = true
	else:
		$RankUpButton.visible = false

func rankUp():
	$RankUpButton.visible = false
	var rankUpPopup = load("res://objects/AreaLocations/LevelUpPopup.tscn")
	var popup = rankUpPopup.instantiate()
	
	var rewardsForPopup = $Rewards.duplicate()
	popup.get_node("Rewards").add_child(rewardsForPopup)
	
	add_child(popup)
	await get_tree().create_timer(0.1).timeout
	$LevelUpPopup/AnimationPlayer.play("rankUp")
	
	
	await get_tree().create_timer(2).timeout
	system.rankUp()
	showCardsNeededForRankUp()
	showRankLabel()
	#showRewards() #TODO

func showRewards():
	$Rewards/GoldLabel.text = str(rankGoldRewards[system.rank])
	
	var container = $Rewards/BuildingsLabel/VBoxContainer
	if system.mainWindow.rankBuildingsArray[system.rank+1].size() > 0:
		for i in container.get_child_count(): #Deleting access labels
			if i != 0:
				container.get_child(i).queue_free()
		
		container.get_child(0).text = "• " + system.mainWindow.rankBuildingsArray[system.rank+1][0].recipyName
		
		if system.mainWindow.rankBuildingsArray[system.rank+1].size() > 1: #Adding new labels with building names 
			for i in system.mainWindow.rankBuildingsArray[system.rank+1].size():
				if i != 0:
					var newLabel = container.get_child(0).duplicate()
					container.add_child(newLabel)
					newLabel.text = "• " + system.mainWindow.rankBuildingsArray[system.rank+1][i].recipyName
		
		$Rewards/BuildingsLabel.visible = true
	else:
		$Rewards/BuildingsLabel.visible = false

func _input(event): #TODELETE
	if event is InputEventKey:
		if event.key_label == 82 and !event.pressed:
			rankUp()
		if event.key_label == 67 and !event.pressed:
			system.addCard(load("res://resources/cards/Mine/package/IronOre.tres"))
			system.addCard(load("res://resources/cards/Mine/package/Coal.tres"))
			system.addCard(load("res://resources/cards/Mine/package/CopperOre.tres"))
			system.addCard(load("res://resources/cards/Mine/package/GoldOre.tres"))
			system.addCard(load("res://resources/cards/Mine/IronBar.tres"))
			system.addCard(load("res://resources/cards/Mine/Cogwell.tres"))
			system.addCard(load("res://resources/cards/Forest/Vase.tres"))
			system.addCard(load("res://resources/cards/Forest/Line.tres"))
			system.addCard(load("res://resources/cards/Forest/SharpenedStone.tres"))
			system.addCard(load("res://resources/cards/Forest/Fire.tres"))
			system.addCard(load("res://resources/cards/Forest/FirePlace.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Wood.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Rock.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Leaf.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Vine.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Stick.tres"))
		if event.key_label == 68 and !event.pressed: #d
			system.moneySystemNode.addMoney(50)
