extends Control

var requiredRecipy : recipy
@onready var system = get_node("/root/MainScene")

func _ready():
	updateDataInList()
	print(requiredRecipy.goldCost,"gc")
	$Button.connect("pressed", func(): system.checkPlayerDecision(self, "Build [color=44FF44]" + requiredRecipy.recipyName + "[/color]?", requiredRecipy.goldCost))

func updateDataInList():
	$NameOfBuilding.text = requiredRecipy.recipyName
	$Image.texture = requiredRecipy.recipyCustomImage
	
	if requiredRecipy.resources.size() > 0:
		$FirstResource.visible = true
		$FirstResource.text = str(requiredRecipy.quantity[0])
		$FirstResource/Image.texture = requiredRecipy.resources[0].image
		$FirstResource/Label.text = requiredRecipy.resources[0].cardName
	
	if requiredRecipy.resources.size() > 1:
		$SecondResource.visible = true
		$SecondResource.text = str(requiredRecipy.quantity[1])
		$SecondResource/Image.texture = requiredRecipy.resources[1].image
		$SecondResource/Label.text = requiredRecipy.resources[1].cardName
	else:
		$SecondResource.visible = false
	
	if requiredRecipy.resources.size() > 2:
		$ThirdResource.visible = true
		$ThirdResource.text = str(requiredRecipy.quantity[2])
		$ThirdResource/Image.texture = requiredRecipy.resources[2].image
		$ThirdResource/Label.text = requiredRecipy.resources[2].cardName
	else:
		$ThirdResource.visible = false
	
	if requiredRecipy.resources.size() > 3:
		$FourthResource.visible = true
		$FourthResource.text = str(requiredRecipy.quantity[3])
		$FourthResource/Image.texture = requiredRecipy.resources[3].image
		$FourthResource/Label.text = requiredRecipy.resources[3].cardName
	else:
		$FourthResource.visible = false
	
	if requiredRecipy.goldCost > 0:
		$Cost.text = str(requiredRecipy.goldCost)
		$Cost.visible = true
	else:
		$Cost.visible = false

func playerDecision(decision): #after yes, no popup; Sends sygnal to empty location through few scripts...
	if decision:
		get_parent().get_parent().build(requiredRecipy)
