extends Control
class_name cardSlot
@export var cardData : card
@export var quantity : int
@onready var cardHolder = get_node("/root/MainScene/CardHolder")
var doubleClicked = false
@onready var system = get_node("/root/MainScene")

func _ready():
	$Background/Item.texture = cardData.image
	$Name.text = cardData.cardName
	$Quantity.text = str(quantity)
	$Button.connect("pressed",select)

func increaseQuantity():
	quantity += 1
	$Quantity.text = str(quantity)

var interactiveCardInstance = preload("res://objects/InteractiveCard.tscn")
func createInteractiveCard():
	var c = interactiveCardInstance.instantiate()
	c.cardData = cardData
	get_node("/root/MainScene").add_child(c)
	c.global_position = global_position + Vector2(50,50)
	return c

func select():
	if cardHolder.selectedCard == self:
		doubleClick()
	else:
		if cardHolder.selectedCard != null:
			cardHolder.selectedCard.unselect()
	cardHolder.selectedCard = self
	$Background.modulate = Color.RED

func unselect():
	doubleClicked = false
	$Background.modulate = Color.WHITE

func doubleClick():
	var requestingFields = get_tree().get_nodes_in_group("requesting")
	for r in requestingFields:
		if r.checkIfAvailable(cardData):
			var c = createInteractiveCard()
			r.addCard(c)
			use()
			return 

func use():
	quantity -= 1
	$Quantity.text = str(quantity)
	if quantity == 0:
		system.cardList.erase(self)
		cardHolder.selectedCard = null
		call_deferred("queue_free")
