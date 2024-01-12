extends Control

var cardList = []
var ForestCardList = []
var MineCardList = []
@export var rank = 1

func addCard(cardData):
	$CardHolder.addCard(cardData)

var interactiveCardInstance = preload("res://objects/InteractiveCard.tscn")
func createInteractiveCard(parentObject, cardData):
	var ic = interactiveCardInstance.instantiate()
	ic.cardData = cardData
	parentObject.add_child(ic)
	ic.global_position = parentObject.global_position
	return ic

func checkPlayerDecision(script,text):
	$Popup.checkPlayerDecision(script,text)

func rankUp():
	rank += 1
	$MainWindow.addNewEmptyLocation()
