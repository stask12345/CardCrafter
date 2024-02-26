extends Control
class_name controlSystem

var cardList = [] #list of all cards slots #if you want to check cardData use checkIfHaveCard()
var ForestCardList = []
var MineCardList = []
var knownRecipies : Array[recipy] = []
var unknownRecipes : Array[recipy] = [] #created using knownRecipies -  craft crafter recipes #In _ready
var builded : Array[recipy]
@export var rank = 0
@export var systemUpgradeRank = 0
@onready var cardHolder = get_node("CardHolder")
@onready var craftingTable = get_node("MainWindow/CraftingTable")
@onready var mainWindow : mainWindowSystem = get_node("MainWindow")
@onready var moneySystemNode : moneySystem = get_node("TopRight")
@onready var popupUpgrade = get_node("PopupUpgrade")
@onready var cardHolderTabs = get_node("BottomMenu/Tabs")

func _ready():
	randomize()
	for ch in $MainWindow.get_children(): #TODELETE
		if ch is AreaLocation:
			ch.visible = false
	$MainWindow.get_child(1).visible = true
	
	unknownRecipes.append_array($MainWindow.get_child(2).availableRecipes)

func checkIfHaveCard(cardData):
	for c in cardList:
		if c.cardData == cardData:
			return c
	return false

func addCard(cardData):
	cardHolder.addCard(cardData)

var interactiveCardInstance = preload("res://objects/Utility/InteractiveCard.tscn")
func createInteractiveCard(parentObject, cardData):
	var ic = interactiveCardInstance.instantiate()
	ic.cardData = cardData
	parentObject.add_child(ic)
	ic.global_position = parentObject.global_position
	return ic

func checkPlayerDecision(script,text,goldCost = 0):
	print(goldCost, "gg")
	$Popup.checkPlayerDecision(script,text, goldCost)

func rankUp():
	rank += 1
	$MainWindow.addNewEmptyLocation()
