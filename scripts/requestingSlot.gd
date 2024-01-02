extends Control
class_name requestingSlot

@export var parentArea : Control
@export var cardLimit : int = 1
enum cardOrdering {stack, exclusive}
@export var ordering : cardOrdering
@export var whiteList : Array[card]
@export var singularType : bool = false
@export_group("special")
@export var eatingFuel : bool = false
@export var magazineStack : bool = false #cards in magazine stacks, are being flown to other location from area parent

func checkIfActive():
	if parentArea.visible:
		return true
	else:
		return false

func checkIfAvailable(c):
	if checkIfActive() and get_child_count() < cardLimit + 1:
		if singularType:
			if get_child_count() > 1:
				if c != get_child(get_child_count()-1):
					return
		if whiteList.size() == 0:
			return true
		if whiteList.has(c):
			return true
		else:
			return false
	else:
		return false

func addCard(c : interactiveCard):
	if get_child_count() >= cardLimit + 1:
		return
	
	var pos = c.global_position
	c.get_parent().remove_child(c)
	add_child(c)
	c.global_position = pos
	
	if !eatingFuel:
		orderCards()
	else:
		c.goingToFuel = true
		c.flyToPoint(global_position)


func deleteCard(c):
	remove_child(c)
	orderCards()

func orderCards():
	if ordering == cardOrdering.stack:
		var index = 1
		for c in get_children():
			if c is interactiveCard:
				c.flyToPoint(global_position + Vector2(20*(index),-20*(index)))
				index += 1
	
	if ordering == cardOrdering.exclusive:
		if get_child_count() == 2:
			get_child(1).flyToPoint(global_position)
		if get_child_count() == 3:
			get_child(2).flyToPoint(global_position + Vector2(75,0))
			get_child(1).flyToPoint(global_position + Vector2(-75,0))
		if get_child_count() == 4:
			get_child(3).flyToPoint(global_position + Vector2(0,-100))
			get_child(1).flyToPoint(global_position + Vector2(-75,60))
			get_child(2).flyToPoint(global_position + Vector2(75,60))

func returnResourceList():
	var resList = []
	for ch in get_children():
		if ch is interactiveCard:
			resList.append(ch.cardData)
	return resList

func deleteAllCards():
	for ch in get_children():
		if ch is interactiveCard:
			ch.queue_free()

func cardArrivedAtGoal(c): #For furnace and magazine card piles. Fires when IC arrives at goal, e.g. furnace
	if eatingFuel: #furnace
		parentArea.addFuel(c.cardData.fuelPower)
		c.queue_free()
	if magazineStack:
		parentArea.cardArrived(c)
		c.queue_free()
