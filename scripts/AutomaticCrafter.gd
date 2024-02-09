extends AreaLocation

var cardSlotsData : Array[card] = []

func _ready():
	$FirstSlot/Timer.connect("timeout",func():craftNewCard(0))

func craftNewCard(slotId):
	var cardData : card
	var slot : Node
	if slotId == 0:
		cardData = cardSlotsData[slotId]
		slot = $FirstSlot
	
	var ic = system.createInteractiveCard(self,cardData)
	slot.get_node("requestingSlot").addCard(ic)
