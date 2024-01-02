extends AreaLocation

@onready var rSlot = $requestingSlot
var fuelPoints : float = 0
var fuelMaxPoints : float = 40

func addFuel(fuel):
	fuelPoints += fuel
	if fuelPoints > fuelMaxPoints:
		fuelPoints = fuelMaxPoints
	updateFuelPowerLabel()

func updateFuelPowerLabel():
	$FuelPower.text  = str((float) (fuelPoints / fuelMaxPoints))
	print(fuelPoints)

func cardAdded(): #Added to pile
	await get_tree().create_timer(0.5).timeout
	if rSlot.get_child_count() > 1:
		var IC : interactiveCard = rSlot.get_child(1)
		IC.goingToFinishGoal = true
		IC.flyToPoint(Vector2(260,330))

func cardArrived(c): #At furnace, begin smelting
	c.queue_free()
