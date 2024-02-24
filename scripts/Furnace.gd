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
	if $ProgressCircle.stopped:
		$ProgressCircle.resumeBar()
	updateFuelBar()
	cardAdded()
	melt()

func updateFuelBar():
	$ProgressBar.updateProgressBar((float) (fuelPoints / fuelMaxPoints))

@onready var locationOfSmelting = $LocationIndicator1
func cardAdded(c = null): #Added to pile #Add cards to furnace
	#await get_tree().create_timer(0.5).timeout
	if rSlot.get_child_count() > 1 and meltingCard == null: #and fuelPoints > 0
		var IC : interactiveCard = rSlot.get_child(1)
		IC.goingToFinishGoal = true
		meltingCard = IC.cardData
		IC.unordering = true
		IC.flyToPoint(locationOfSmelting.global_position)

func cardArrived(c): #At furnace, begin smelting
	$Furnace/FurnaceSmelter/AnimationPlayer.play("close")
	startMelting(c)
	c.queue_free()

var meltingCard : card = null
func startMelting(c):
	meltingCard = c.cardData
	melt()
	await get_tree().create_timer(0.5).timeout
	rSlot.orderCards()
	
	await get_tree().create_timer((meltingCard.fuelNeededInProduction/processingPower)*0.1).timeout

var meltingProgess : float = 0
var progressCircleStarted = false
func melt():
	if meltingCard != null and fuelPoints > 0 and melting == false:
		if !progressCircleStarted:
			$ProgressCircle.visible = true
			$ProgressCircle.startBar((meltingCard.fuelNeededInProduction/processingPower)*0.1*1.17,true)
			progressCircleStarted = true
		
		$Furnace/FurnaceFireplace/AnimationPlayerMelting.play("melting")
		if meltingProgess >= meltingCard.fuelNeededInProduction: #melting ended successfully
			$ProgressCircle.visible = false
			progressCircleStarted = false
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
		
		updateFuelBar()
		
		if fuelPoints <= processingPower: #not enought fuel points
			melting = false
			$ProgressCircle.stopBar()
			meltingProgess += fuelPoints
			fuelPoints = 0
			$Timer.stop()
			$Furnace/FurnaceFireplace/AnimationPlayerMelting.play("meltingOff")
		else:
			melting = true
			fuelPoints -= processingPower
			meltingProgess += processingPower
			$Timer.start()
			await $Timer.timeout
			melting = false
			melt()


func addingCard(req):
	if req == rSlot:
		if meltingCard == null:
			call_deferred("cardAdded")
	if req == rSlot2:
		$Furnace/FurnaceFireplace/AnimationPlayer.play("open")

func cardCollectedFromOutput():
	melt()
