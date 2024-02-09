extends Control

var choosenRecipy : recipy = null
var addedResources : recipy

func setUpRecipy(rec):
	choosenRecipy = rec
	addedResources = recipy.new()
	updateNeededCards()

@onready var container = get_node("CenterContainer/HBoxContainer")
func updateNeededCards():
	for i in 4:
		if choosenRecipy.resources.size() > i:
			if !$requestingSlot.whiteList.has(choosenRecipy.resources[i]):
				$requestingSlot.whiteList.append(choosenRecipy.resources[i])
			
			if !addedResources.resources.has(choosenRecipy.resources[i]):
				container.get_child(i).text = "x " + str(choosenRecipy.quantity[i])
				container.get_child(i).visible = true
				container.get_child(i).get_child(0).texture = choosenRecipy.resources[i].image
				continue
			else:
				var resourceIndex = addedResources.resources.find(choosenRecipy.resources[i])
				if choosenRecipy.quantity[i] > addedResources.quantity[resourceIndex]:
					container.get_child(i).text = "x " + str(choosenRecipy.quantity[i] - addedResources.quantity[resourceIndex])
					container.get_child(i).visible = true
					container.get_child(i).get_child(0).texture = choosenRecipy.resources[i].image
					continue
			
			if $requestingSlot.whiteList.has(choosenRecipy.resources[i]):
				$requestingSlot.whiteList.erase(choosenRecipy.resources[i])
				container.get_child(i).visible = false
		else:
			container.get_child(i).visible = false

func cardArrived(c):
	if addedResources.resources.has(c.cardData):
		var resourceIndex = addedResources.resources.find(c.cardData)
		addedResources.quantity[resourceIndex] += 1
	else:
		addedResources.resources.append(c.cardData)
		addedResources.quantity.append(1)
	
	c.queue_free()
	if choosenRecipy.checkIfRecipiesEqual(addedResources):
		get_parent().allResourcesCollected()
	updateNeededCards()
