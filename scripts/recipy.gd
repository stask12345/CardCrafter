extends Resource
class_name recipy

@export var resources : Array[card]
@export var quantity : Array[int]
@export var outputResource : Array[card]
@export_category("special")
@export var recipyName : String
@export var recipyCustomImage : Texture2D
@export var customOutputObject : PackedScene

func checkValidity(listOfResources):
	var neededResources = []
	for i in resources.size():
		for o in quantity[i]:
			neededResources.append(resources[i])
	
	for r in listOfResources:
		if !neededResources.has(r):
			return false
	
	if listOfResources.size() == neededResources.size():
		return true
	else:
		return false

func checkIfRecipiesEqual(rec : recipy):
	if resources.size() != rec.resources.size():
		return false
	
	for i in resources:
		if rec.quantity[rec.resources.find(i)] != quantity[resources.find(i)]:
			return false
	
	return true

var interactiveCardInstance = preload("res://objects/InteractiveCard.tscn")
func returnOutputCard(): #TO DO? currently returns only 1 card
	var ic = interactiveCardInstance.instantiate()
	ic.cardData = outputResource[0]
	return ic
