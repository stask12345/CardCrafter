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
			if !$"../requestingSlot".whiteList.has(choosenRecipy.resources[i]):
				$"../requestingSlot".whiteList.append(choosenRecipy.resources[i])
			
			if !addedResources.resources.has(choosenRecipy.resources[i]):
				container.get_child(i).text = "x " + str(choosenRecipy.quantity[i])
				container.get_child(i).visible = true
				container.get_child(i).get_node("Image").texture = choosenRecipy.resources[i].image
				container.get_child(i).get_node("Name").text = choosenRecipy.resources[i].cardName
				continue
			else:
				var resourceIndex = addedResources.resources.find(choosenRecipy.resources[i])
				if choosenRecipy.quantity[i] > addedResources.quantity[resourceIndex]:
					container.get_child(i).text = "x " + str(choosenRecipy.quantity[i] - addedResources.quantity[resourceIndex])
					container.get_child(i).visible = true
					container.get_child(i).get_node("Image").texture = choosenRecipy.resources[i].image
					container.get_child(i).get_node("Name").text = choosenRecipy.resources[i].cardName
					continue
			
			if $"../requestingSlot".whiteList.has(choosenRecipy.resources[i]):
				$"../requestingSlot".whiteList.erase(choosenRecipy.resources[i])
				container.get_child(i).visible = false
		else:
			container.get_child(i).visible = false

func cardArrived(c):
	c.playDestroyAnim()
	await get_tree().create_timer(0.6).timeout

func collectedResources():
	print("collected!!!!!!!!!!!!!!!!")
	get_parent().resourcesCollected()

func addingCard(slot):
	var c = slot.get_child(slot.get_child_count()-1).cardData
	if addedResources.resources.find(c) != -1:
		var index = addedResources.resources.find(c)
		if addedResources.quantity[index] + 1 >= choosenRecipy.quantity[choosenRecipy.resources.find(c)]:
			$"../requestingSlot".whiteList.erase(c)
	
	if addedResources.resources.has(c):
		var resourceIndex = addedResources.resources.find(c)
		addedResources.quantity[resourceIndex] += 1
	else:
		addedResources.resources.append(c)
		addedResources.quantity.append(1)
	
	var countNeeded : float = 0
	var countAlreadyAdded : float = 0
	for i in addedResources.quantity:
		countAlreadyAdded += i
	for i in choosenRecipy.quantity:
		countNeeded += i
	
	if get_parent().has_node("ProgressBar/ProgressBar"):
		$"../ProgressBar/ProgressBar".updateProgressBar((float) (countAlreadyAdded/countNeeded))
	
	updateNeededCards()
	if choosenRecipy.checkIfRecipiesEqual(addedResources):
		await get_tree().create_timer(1).timeout
		collectedResources()
