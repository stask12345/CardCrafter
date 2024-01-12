extends AreaLocation

@export var rankRecipies : Array[recipy]
@export var rankNames : Array[String]
@onready var system = get_node("/root/MainScene")
@onready var container = $CenterContainer/GridContainer

func _ready():
	showCardsNeededForRankUp()
	showRankLabel()
	$RankUpButton.connect("pressed",rankUp)

@onready var cardPlaceholder = preload("res://objects/PlaceHolderCard.tscn")
func showCardsNeededForRankUp():
	for ch in container.get_children():
		ch.queue_free()
	
	for r in rankRecipies[system.rank-1].resources:
		var cp = cardPlaceholder.instantiate()
		cp.cardData = r
		container.add_child(cp)
		cp.get_node("requestingSlot").parentArea = self
		cp.get_node("requestingSlot").whiteList.append(r)

func showRankLabel():
	$Rank.text = "Rank " + str(system.rank-1)
	$RankDescription.text = rankNames[system.rank-1]

func cardAdded():
	checkCardsForRankingUp()

func cardDeleted():
	checkCardsForRankingUp()

func checkCardsForRankingUp():
	var rSlots = container.get_children()
	var listOfRes = []
	for r in rSlots:
		var rs = r.get_node("requestingSlot")
		listOfRes.append(rs.getHoldedCard())
	
	if rankRecipies[system.rank-1].checkValidity(listOfRes):
		$RankUpButton.visible = true
	else:
		$RankUpButton.visible = false

func rankUp():
	system.rankUp()
	showCardsNeededForRankUp()
	showRankLabel()
	$RankUpButton.visible = false
