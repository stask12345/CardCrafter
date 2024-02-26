extends AreaLocation

var buildingRecipy : recipy

func _ready():
	actionOnAddingCard = true

func setUpBuildingSite(rec):
	buildingRecipy = rec
	$NameOfBuilding.text = buildingRecipy.recipyName
	$ListOfNeededItem.setUpRecipy(rec)

func cardArrived(c):
	$ListOfNeededItem.cardArrived(c)
	#$CardAddedBuild/AnimationPlayer.play("build")

#func allResourcesCollected():
	#get_parent().buildingCompleted()

func resourcesCollected():
	get_parent().buildingCompleted()

func addingCard(c):
	$ListOfNeededItem.addingCard(c)
