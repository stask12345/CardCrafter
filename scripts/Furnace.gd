extends AreaLocation


@onready var rSlot = $requestingSlot
@onready var rSlot2 = $requestingSlot2
@onready var rSlotOutput = $requestingSlot3
var fuelPoints : float = 0
var fuelMaxPoints : float = 40
@export var processingPower : float = 0.2
var melting = false

func _ready():
	actionOnAddingCard = true

func addFuel(fuel):
	fuelPoints += fuel
	if fuelPoints > fuelMaxPoints:
		fuelPoints = fuelMaxPoints
	$Furnace/FurnaceFireplace/AnimationPlayer.play("close")
	updateFuelPowerLabel()
	cardAdded()
	melt()

func updateFuelPowerLabel():
	$FuelPower.text  = str((float) (fuelPoints / fuelMaxPoints))
	print(fuelPoints)

@onready var locationOfSmelting = $LocationIndicator1
func cardAdded(c = null): #Added to pile #Add cards to furnace
	#await get_tree().create_timer(0.5).timeout
	if rSlot.get_child_count() > 1 and !melting: #and fuelPoints > 0
		var IC : interactiveCard = rSlot.get_child(1)
		IC.goingToFinishGoal = true
		IC.flyToPoint(locationOfSmelting.global_position)

func cardArrived(c): #At furnace, begin smelting
	$Furnace/FurnaceSmelter/AnimationPlayer.play("close")
	startMelting(c)
	c.queue_free()

var meltingCard : card = null
func startMelting(c):
	meltingCard = c.cardData
	melting = true
	print("melting")
	melt()
	await get_tree().create_timer(0.5).timeout
	rSlot.orderCards()

var meltingProgess : float = 0
func melt():
	if meltingCard != null and fuelPoints > 0:
		$Furnace/FurnaceFireplace/AnimationPlayerMelting.play("melting")
		if meltingProgess >= meltingCard.fuelNeededInProduction: #melting ended successfully
			$Furnace/FurnaceFireplace/AnimationPlayerMelting.play("meltingOff")
			if rSlotOutput.checkIfFull():
				meltingProgess = 0
				var ic = get_node("/root/MainScene").createInteractiveCard(self,meltingCard.outputCard)
				ic.global_position = locationOfSmelting.global_position
				meltingCard = null
				ic.toPick = true
				melting = false
				ic.flyToPoint(rSlotOutput.global_position)
				rSlotOutput.addCard(ic)
				$Furnace/FurnaceSmelter/AnimationPlayer.play("open")
				await get_tree().create_timer(0.5).timeout
				cardAdded()
			else:
				print("OUTPUT FULL!") #TODO
			return
		
		updateFuelPowerLabel()
		$BurningIndicator.text = str((float) (meltingProgess) / (float)(meltingCard.fuelNeededInProduction))
		
		if fuelPoints <= processingPower: #not enought fuel points
			meltingProgess += fuelPoints
			fuelPoints = 0
			$Timer.stop()
			$Furnace/FurnaceFireplace/AnimationPlayerMelting.play("meltingOff")
		else:
			fuelPoints -= processingPower
			meltingProgess += processingPower
			$Timer.start()
			await $Timer.timeout
			melt()

func addingCard(req):
	if req == rSlot:
		if meltingCard == null:
			cardAdded()
	if req == rSlot2:
		$Furnace/FurnaceFireplace/AnimationPlayer.play("open")

func cardCollectedFromOutput():
	melt()
