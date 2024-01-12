extends AreaLocation

@onready var rSlot = $requestingSlot
var fuelPoints : float = 0
var fuelMaxPoints : float = 40
@export var processingPower : float = 0.2
var melting = false

func addFuel(fuel):
	fuelPoints += fuel
	if fuelPoints > fuelMaxPoints:
		fuelPoints = fuelMaxPoints
	updateFuelPowerLabel()
	cardAdded()
	melt()

func updateFuelPowerLabel():
	$FuelPower.text  = str((float) (fuelPoints / fuelMaxPoints))
	print(fuelPoints)

func cardAdded(): #Added to pile #Add cards to furnace
	await get_tree().create_timer(0.5).timeout
	if rSlot.get_child_count() > 1 and !melting and fuelPoints > 0:
		var IC : interactiveCard = rSlot.get_child(1)
		IC.goingToFinishGoal = true
		IC.flyToPoint(Vector2(260,330))

func cardArrived(c): #At furnace, begin smelting
	startMelting(c)
	c.queue_free()

var meltingCard : card = null
func startMelting(c):
	meltingCard = c.cardData
	melting = true
	melt()

var meltingProgess : float = 0
func melt():
	if meltingCard != null and fuelPoints > 0:
		if meltingProgess >= meltingCard.fuelNeededInProduction:
			cardAdded()
			meltingProgess = 0
			var ic = get_node("/root/MainScene").createInteractiveCard(self,meltingCard.meltingOutputCard)
			ic.global_position = Vector2(285,425)
			meltingCard = null
			ic.toPick = true
			melting = false
			return
		
		updateFuelPowerLabel()
		$BurningIndicator.text = str((float) (meltingProgess) / (float)(meltingCard.fuelNeededInProduction))
		
		if fuelPoints <= processingPower: #not enought fuel points
			meltingProgess += fuelPoints
			fuelPoints = 0
			$Timer.stop()
		else:
			fuelPoints -= processingPower
			meltingProgess += processingPower
			$Timer.start()
			await $Timer.timeout
			melt()


