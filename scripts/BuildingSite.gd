extends AreaLocation

var neededRecipy : recipy
var addedResources : recipy

func setUpBuildingSite(rec):
	neededRecipy = rec
	$NameOfBuilding.text = neededRecipy.recipyName
	addedResources = recipy.new()
	updateNeededCards()

func cardArrived(c):
	if addedResources.resources.has(c.cardData):
		var resourceIndex = addedResources.resources.find(c.cardData)
		addedResources.quantity[resourceIndex] += 1
	else:
		addedResources.resources.append(c.cardData)
		addedResources.quantity.append(1)
	
	c.queue_free()
	if neededRecipy.checkIfRecipiesEqual(addedResources):
		buildingCompleted()
	updateNeededCards()

@onready var container = get_node("CenterContainer/HBoxContainer")
func updateNeededCards():
	for i in 4:
		if !$requestingSlot.whiteList.has(neededRecipy.resources[i]):
			$requestingSlot.whiteList.append(neededRecipy.resources[i])
		
		if neededRecipy.resources.size() > i:
			if !addedResources.resources.has(neededRecipy.resources[i]):
				container.get_child(i).text = "x " + str(neededRecipy.quantity[i])
				container.get_child(i).visible = true
				container.get_child(i).get_child(0).texture = neededRecipy.resources[i].image
				continue
			else:
				var resourceIndex = addedResources.resources.find(neededRecipy.resources[i])
				if neededRecipy.quantity[i] > addedResources.quantity[resourceIndex]:
					container.get_child(i).text = "x " + str(neededRecipy.quantity[i] - addedResources.quantity[resourceIndex])
					container.get_child(i).visible = true
					container.get_child(i).get_child(0).texture = neededRecipy.resources[i].image
					continue
		
		$requestingSlot.whiteList.erase(neededRecipy.resources[i])
		container.get_child(i).visible = false

func buildingCompleted():
	get_parent().buildingCompleted()
