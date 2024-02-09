extends ScrollContainer

@onready var system = get_node("/root/MainScene")
var selectedCard : cardSlot = null

func _ready():
	for cardBox in get_children():
		cardBox.get_node("Control/Button").connect("pressed",unselectCard)
	$"../UnselectButton".connect("pressed",unselectCard)

var emptyCard = preload("res://objects/Utility/Card.tscn")
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
				c.newCardAnimation()
				c.increaseQuantity()
				return
		index += 1
	handToAdd.add_child(c)
	handToAdd.move_child(c,index-1)
	c.increaseQuantity()
	c.newCardAnimation()

func changePlayerHand(numberOfMenu):
	var tabs = system.cardHolderTabs
	
	for i in tabs.get_child_count(): #animation
		if i != numberOfMenu:
			var tab = tabs.get_child(i)
			var t = get_tree().create_tween()
			t.tween_property(tab,"modulate",Color(0.5,0.5,0.5),0.3)
			t.parallel().tween_property(tab,"position:y",-175,0.3)
	
	var t1 = get_tree().create_tween()
	var tab1 = tabs.get_child(numberOfMenu)
	t1.tween_property(tab1,"modulate",Color(1,1,1),0.3)
	t1.parallel().tween_property(tab1,"position:y",-185,0.3)
	
	for c in get_children(): #changing visibility of cards
		c.visible = false
	get_child(numberOfMenu).visible = true

func unselectCard():
	if selectedCard != null:
		selectedCard.unselect()
		selectedCard = null

