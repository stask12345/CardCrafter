extends Resource
class_name package

@export var packageName : String
@export var cardCollection : Array[card]
@export var cardCollectionRare : Array[card]
@export var costMoney : int
@export var costResources : Array[card]
@export var costResourcesQuantity : Array[int]
const rareCardProbability = 20

func getRandomArray(packageSize):
	var arr = []
	for i in packageSize:
		arr.append(getRandomCard())
	return arr

func getNonRandomArray(packageSize): #without duplicates
	var arr = []
	TemporaryCardArray.clear()
	TemporaryCardArray.append_array(cardCollection)
	for i in packageSize:
		arr.append(getNonRandomCard())
	return arr

func getRandomCard():
	if randi()%rareCardProbability == 0:
		if cardCollectionRare.size() != 0:
			return cardCollectionRare.pick_random()
	return cardCollection.pick_random()

var TemporaryCardArray = []
func getNonRandomCard():
	if randi()%rareCardProbability == 0:
		if cardCollectionRare.size() != 0:
			return cardCollectionRare.pick_random()
	var choosenCard = TemporaryCardArray.pick_random()
	TemporaryCardArray.erase(choosenCard)
	return choosenCard
