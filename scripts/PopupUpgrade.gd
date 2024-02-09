extends Control

var choosenRecipy : recipy
var objectToReturn : AreaLocation
var idToReturn : int
@onready var system = get_node("/root/MainScene")

func _ready():
	$ButtonNo.connect("pressed",exitMenu)
	$ButtonYes.connect("pressed",upgrade)

func showUpgradeMenu(rec : recipy,object = AreaLocation, id = 0, isUpgrade = true):
	choosenRecipy = rec
	objectToReturn = object
	idToReturn = id
	if isUpgrade:
		$RichTextLabel.text = "Upgrade "
	else:
		$RichTextLabel.text = "Build "
	$RichTextLabel.text += "[color=FF0000]" + rec.recipyName + "[/color]?"
	
	$ListOfNeededItem.setUpList(rec)
	
	visible = true

func exitMenu():
	visible = false

func checkResources():
	for i in choosenRecipy.resources.size():
		var c = system.checkIfHaveCard(choosenRecipy.resources[i])
		if c:
			if c.quantity < choosenRecipy.quantity[i]:
				return false
		else:
			return false
	
	return true

func upgrade():
	if checkResources():
		for i in choosenRecipy.resources.size():
			var c = system.checkIfHaveCard(choosenRecipy.resources[i])
			c.use(choosenRecipy.quantity[i])
		
		exitMenu()
		objectToReturn.upgradeBought(idToReturn)
