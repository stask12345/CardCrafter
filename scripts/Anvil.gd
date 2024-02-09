extends AreaLocation

var duringIroning : bool = false

func _ready():
	$Button.connect("pressed",openMenu)
	$Ironing/ButtonAnvil.connect("pressed",hit)

func openMenu():
	$AnvilMenu.visible = true

func hideAnvilMenu():
	$AnvilMenu.visible = false

func setUpRecipy(rec):
	$ListOfNeededItems.setUpRecipy(rec)
	$ListOfNeededItems.visible = true
	$Button.visible = false

func cardArrived(c):
	$ListOfNeededItems.cardArrived(c)

func allResourcesCollected():
	$ListOfNeededItems.visible = false
	$Ironing.visible = true
	duringIroning = true

var currentProcessingProgress : float = 0
func hit():
	currentProcessingProgress += 1
	var progress = (float) (currentProcessingProgress / $ListOfNeededItems.choosenRecipy.outputResource[0].processingPowerNeeded)
	$Ironing/Label.text = str(progress)
	if progress >= 1:
		ironingCompleted()

@onready var locationIndicator = get_node("Ironing/LocationIndicator1")
func ironingCompleted():
	var ic = system.createInteractiveCard(self, $ListOfNeededItems.choosenRecipy.outputResource[0])
	ic.global_position = locationIndicator.global_position
	ic.flyToHand()
	
	setUpRecipy($ListOfNeededItems.choosenRecipy) #repeat process
	$ListOfNeededItems.visible = true
	$Ironing.visible = false
	duringIroning = false
