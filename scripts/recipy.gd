extends Resource
class_name recipy

@export var resources : Array[card]
@export var quantity : Array[int]
@export var outputResource : Array[card]

func checkValidity(listOfResources):
	var neededResources = []
	for i in resources.size():
		for o in quantity[i]:
			neededResources.append(resources[i])
	
	if neededResources == listOfResources:
		return true
	else:
		return false

var interactiveCardInstance = preload("res://objects/InteractiveCard.tscn")
func returnOutputCard(): #TO DO? currently returns only 1 card
	var ic = interactiveCardInstance.instantiate()
	ic.cardData = outputResource[0]
	return ic
