extends Resource
class_name package

@export var packageName : String
@export var cardCollection : Array[card]
@export var cardCollectionRare : Array[card]
@export var costMoney : int
@export var costResources : Array[card]
@export var costResourcesQuantity : Array[int]

func getRandomCard():
	if randi()%20 == 0:
		if cardCollectionRare.size() != 0:
			return cardCollectionRare.pick_random()
	return cardCollection.pick_random()
