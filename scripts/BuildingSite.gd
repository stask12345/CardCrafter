extends AreaLocation

var buildingRecipy : recipy

func setUpBuildingSite(rec):
	buildingRecipy = rec
	$NameOfBuilding.text = buildingRecipy.recipyName
	$ListOfNeededItem.setUpRecipy(rec)

func cardArrived(c):
	$ListOfNeededItem.cardArrived(c)
	#$CardAddedBuild/AnimationPlayer.play("build")

func allResourcesCollected():
	get_parent().buildingCompleted()

func resourcesCollected():
	$"ProgressBar".visible = false
	$"NameOfBuilding".visible = false
	$"CancelButton".visible = false
	
	for ch in $"Clouds/Control1".get_children():
		var t = get_tree().create_tween()
		t.tween_property(ch,"rotation_degrees",30,4)
	
	for ch in $"Clouds/Control2".get_children():
		var t = get_tree().create_tween()
		t.tween_property(ch,"rotation_degrees",-30,4)
	
	for ch in $"Clouds/control3".get_children():
		var t = get_tree().create_tween()
		t.tween_property(ch,"rotation_degrees",-30,4)
	
	$CardSlot.visible = false
	$"Clouds/AnimationPlayer".play("built")
