extends Control

var requiredRecipy : recipy
@onready var system = get_node("/root/MainScene")

func _ready():
	updateDataInList()
	$Button.connect("pressed", func(): system.checkPlayerDecision(self, "Build [color=FF0000]" + requiredRecipy.recipyName + "[/color]?"))

func updateDataInList():
	$NameOfBuilding.text = requiredRecipy.recipyName
	$Image.texture = requiredRecipy.recipyCustomImage
	
	if requiredRecipy.resources.size() > 0:
		$FirstResource.visible = true
		$FirstResource.text = "x " + str(requiredRecipy.quantity[0])
		$FirstResource/TengraiImage17035893644173577.texture = requiredRecipy.resources[0].image
	
	if requiredRecipy.resources.size() > 1:
		$SecondResource.visible = true
		$SecondResource.text = "x " + str(requiredRecipy.quantity[1])
		$SecondResource/TengraiImage17035893644173577.texture = requiredRecipy.resources[1].image
	
	if requiredRecipy.resources.size() > 2:
		$ThirdResource.visible = true
		$ThirdResource.text = "x " + str(requiredRecipy.quantity[2])
		$ThirdResource/TengraiImage17035893644173577.texture = requiredRecipy.resources[2].image
	
	if requiredRecipy.resources.size() > 3:
		$FourthResource.visible = true
		$FourthResource.text = "x " + str(requiredRecipy.quantity[3])
		$FourthResource/TengraiImage17035893644173577.texture = requiredRecipy.resources[3].image

func playerDecision(decision): #after yes, no popup; Sends sygnal to empty location through few scripts...
	if decision:
		get_parent().get_parent().build(requiredRecipy)
