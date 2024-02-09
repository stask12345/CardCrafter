extends Control
class_name cardSlot
@export var cardData : card
@export var quantity : int
@onready var cardHolder = get_node("/root/MainScene/CardHolder")
var doubleClicked = false
@onready var system = get_node("/root/MainScene")
@export var placeholderCard : bool = false

func _ready():
	$Center/Item.texture = cardData.image
	$Name.text = cardData.cardName
	
	if $Name.text.length() > 7:
		$Name.scale = Vector2(0.8,0.8)
	
	if !placeholderCard:
		$Quantity.text = str(quantity)
		$Button.connect("pressed",select)

func increaseQuantity():
	quantity += 1
	$Quantity.text = str(quantity)
	if colorTween == null or !colorTween.is_running():
		changeLabelColor(Color(0.2,1,0.2))

var interactiveCardInstance = preload("res://objects/Utility/InteractiveCard.tscn")
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
	$Center.modulate = Color.RED

func unselect():
	doubleClicked = false
	$Center.modulate = Color.WHITE

func doubleClick():
	var requestingFields = get_tree().get_nodes_in_group("requesting")
	for r in requestingFields:
		if r.checkIfAvailable(cardData):
			var c = createInteractiveCard()
			r.addCard(c)
			use()
			return 

func use(number : int = 1):
	quantity -= number
	$Quantity.text = str(quantity)
	changeLabelColor(Color(1,0.2,0.2))
	if quantity == 0:
		system.cardList.erase(self)
		cardHolder.selectedCard = null
		call_deferred("queue_free")

func newCardAnimation():
	modulate.a = 0.7
	var previousScale = $Card.scale
	$Card.scale = Vector2(previousScale.x * 0.75,previousScale.y * 0.75)
	$Center.scale = Vector2(0.75,0.75)
	
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_SPRING)
	t.set_ease(Tween.EASE_OUT)
	
	t.tween_property(self,"modulate:a",1,0.3)
	t.parallel().tween_property($Card,"scale",previousScale,0.3)
	t.parallel().tween_property($Center,"scale",Vector2(1,1),0.3)


var colorTween : Tween = null
func changeLabelColor(color):
	colorTween = get_tree().create_tween()
	colorTween.set_trans(Tween.TRANS_CUBIC)
	colorTween.set_ease(Tween.EASE_OUT)
	
	colorTween.tween_property($Quantity,"self_modulate",color,0.3)
	if color != Color(1,1,1):
		colorTween.tween_callback(func():changeLabelColor(Color(1,1,1)))
