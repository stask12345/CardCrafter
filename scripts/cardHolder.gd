extends ScrollContainer

@onready var system = get_node("/root/MainScene")
var selectedCard : cardSlot = null

func _ready():
	for cardBox in get_children():
		cardBox.get_node("Control/Button").connect("pressed",unselectCard)
	$"../UnselectButton".connect("pressed",unselectCard)

var emptyCard = preload("res://objects/Card.tscn")
func addCard(cardData):
	for c in system.cardList: #Card already in hand
		if cardData == c.cardData:
			c.increaseQuantity()
			return
	
	var c = emptyCard.instantiate() #Adding new card
	c.cardData = cardData
	var handToAdd
	if c.cardData.origin == card.orginType.forest:
		handToAdd = $CardBox
	if c.cardData.origin == card.orginType.mine:
		handToAdd = $CardBox1
	system.cardList.append(c)
	
	var index = 0
	for h in handToAdd.get_children():
		if h is cardSlot:
			if c.cardData.handOrder < h.cardData.handOrder:
				handToAdd.add_child(c)
				handToAdd.move_child(c,index)
				return
		index += 1
	handToAdd.add_child(c)
	handToAdd.move_child(c,index-1)

func changePlayerHand(numberOfMenu):
	for c in get_children():
		c.visible = false
	get_child(numberOfMenu).visible = true

func unselectCard():
	if selectedCard != null:
		selectedCard.unselect()
		selectedCard = null

