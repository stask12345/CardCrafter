extends AreaLocation

@export var rankRecipies : Array[recipy]
@export var rankNames : Array[String]
@onready var container = $CenterContainer/GridContainer

func _ready():
	showCardsNeededForRankUp()
	showRankLabel()
	$RankUpButton.connect("pressed",rankUp)
	await get_tree().create_timer(1).timeout

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
	
	print(listOfRes)
	if rankRecipies[system.rank].checkValidity(listOfRes):
		$RankUpButton.visible = true
	else:
		$RankUpButton.visible = false

func rankUp():
	system.rankUp()
	showCardsNeededForRankUp()
	showRankLabel()
	$RankUpButton.visible = false


func _input(event): #TODELETE
	if event is InputEventKey:
		if event.key_label == 82 and !event.pressed:
			rankUp()
		if event.key_label == 67 and !event.pressed:
			system.addCard(load("res://resources/cards/Mine/package/IronOre.tres"))
			system.addCard(load("res://resources/cards/Mine/package/Coal.tres"))
			system.addCard(load("res://resources/cards/Mine/IronBar.tres"))
			system.addCard(load("res://resources/cards/Forest/Vase.tres"))
			system.addCard(load("res://resources/cards/Forest/Fire.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Wood.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Rock.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Leaf.tres"))
			system.addCard(load("res://resources/cards/Forest/package/Vine.tres"))
		if event.key_label == 68 and !event.pressed:
			system.addCard(load("res://resources/cards/Forest/package/Stick.tres"))
