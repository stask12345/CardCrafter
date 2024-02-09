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
	var currentQuantity = []
	currentQuantity.append_array(quantity)
	
	var numberOfNeededResources = 0
	for q in quantity:
		numberOfNeededResources += q
	if listOfResources.size() != numberOfNeededResources:
		return false
	
	for r in listOfResources:
		if !resources.has(r):
			return false
		var index = resources.find(r)
		if currentQuantity[index] <= 0:
			return false
		else:
			currentQuantity[index] -= 1
	
	print("current", currentQuantity)
	print("q",quantity)
	return true

func checkIfRecipiesEqual(rec : recipy):
	if resources.size() != rec.resources.size():
		return false
	
	for i in resources:
		if rec.quantity[rec.resources.find(i)] != quantity[resources.find(i)]:
			return false
	
	return true

var interactiveCardInstance = preload("res://objects/Utility/InteractiveCard.tscn")
func returnOutputCard(): #TO DO? currently returns only 1 card
	var ic = interactiveCardInstance.instantiate()
	ic.cardData = outputResource[0]
	return ic
