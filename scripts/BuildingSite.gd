extends AreaLocation

var buildingRecipy : recipy

func setUpBuildingSite(rec):
	buildingRecipy = rec
	$NameOfBuilding.text = buildingRecipy.recipyName
	$ListOfNeededItem.setUpRecipy(rec)

func cardArrived(c):
	$ListOfNeededItem.cardArrived(c)


func allResourcesCollected():
	get_parent().buildingCompleted()
